#include <signal.h>
#include <experimental/filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include "json.hpp"

#include <boost/regex.hpp>
#include <regex>

namespace fs = std::experimental::filesystem;

namespace {
std::string readFile(const fs::path& p) {
    std::ifstream t(p.c_str());
    return std::string{(std::istreambuf_iterator<char>(t)),
                       std::istreambuf_iterator<char>()};
}
}  // namespace

namespace config {

void signalProcesses(const std::string& name, int signalNumber) {
    for (const auto& p : fs::directory_iterator("/proc")) {
        if (fs::is_directory(p)) {
            fs::path commandPath = p / "comm";
            auto content = readFile(commandPath);
            content.erase(std::remove(content.begin(), content.end(), '\n'),
                          content.end());
            if (content == name) {
                std::string pid = p.path().string();
                pid.erase(0, 6);
                pid_t p = static_cast<pid_t>(std::atoi(pid.c_str()));
                std::cout << "Found " << p << std::endl;
                kill(p, signalNumber);
            }
        }
    }
}

void linkTermite(const fs::path& configDir, const std::string& symlinkFileName,
                 const std::string& name) {
    const fs::path themePath =
        configDir / "themes" / fs::path{name + ".config"};

    if (!fs::exists(configDir)) {
        const std::string error =
            std::string{"Dir "} + configDir.string() + " does not exists";
        throw std::runtime_error(error);
    }

    if (fs::exists(configDir / symlinkFileName) &&
        not fs::remove(configDir / symlinkFileName)) {
        throw std::runtime_error("unable to remove");
    }

    fs::create_symlink(themePath, configDir / symlinkFileName);

    // send signal to all process
    signalProcesses("termite", SIGUSR1);
}

void change_vim(const fs::path& pathToConfig, const std::string& colorscheme,
                const std::string& background) {
    if (!fs::exists(pathToConfig)) {
        throw std::runtime_error("File not found");
    }

    std::string nvimConfig = readFile(pathToConfig.string());

    boost::regex exp("[\"]?colorscheme\\s\\w*\\s*\n");

    auto result = boost::regex_replace(nvimConfig, exp, "");
    exp = "set\\s*background=\\w*\\n";
    result = boost::regex_replace(result, exp, "");

    result += "\ncolorscheme ";
    result += colorscheme;
    result += "\nset background=";
    result += background;
    result += "\n";

    std::cout << result << std::endl;
}

}  // namespace config

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Incorrect arguments number" << std::endl;
        return EXIT_FAILURE;
    }

    auto json = readFile(fs::path{std::getenv("HOME")} / ".colors.json");

    const std::string theme{argv[1]};

    try {
        auto j = nlohmann::json::parse(json);
        if (j["themes"].find(theme) == j["themes"].end()) {
            std::cerr << "No theme " << theme << std::endl;
            return EXIT_FAILURE;
        }
        config::change_vim(
            fs::path{std::getenv("HOME")} /
                j["programs"]["nvim"]["dir"].get<std::string>(),
            j["themes"][theme]["nvim"]["colorscheme"].get<std::string>(),
            j["themes"][theme]["nvim"]["background"].get<std::string>());
    } catch (const std::exception& p) {
        std::cerr << "Unable to parse " << std::endl;
    }

    // config::linkTermite(
    // fs::path{std::getenv("HOME")} /
    // fs::path{j["programs"]["termite"]["dir"].get<std::string>()},
    // j["programs"]["termite"]["config"], j["themes"][theme]["termite"]);

    return 0;
}
