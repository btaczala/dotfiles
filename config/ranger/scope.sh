#!/usr/bin/env bash
# Preview script for ranger (scope.sh).
# Args: $1 file, $2 preview width, $3 preview height, $4 image cache path, $5 image previews enabled.
# Exit codes: 0 = show stdout as preview, 1 = no preview, 2 = show plain file
# content, 6 = show image at $4, 7 = show the file itself as an image.

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH=${1}
PV_WIDTH=${2}
PV_HEIGHT=${3}
IMAGE_CACHE_PATH=${4}

mime=$(file --brief --mime-type -- "$FILE_PATH")

case "$mime" in
# images are previewed by ranger itself (preview_images_method kitty)
image/*)
	exit 7
	;;
text/* | application/json | application/xml | application/javascript | application/x-sh | inode/x-empty)
	if command -v bat >/dev/null 2>&1; then
		bat --color=always --style=numbers --line-range=:"$PV_HEIGHT" -- "$FILE_PATH"
	else
		head -n "$PV_HEIGHT" -- "$FILE_PATH"
	fi
	exit 0
	;;
application/pdf)
	if command -v pdftoppm >/dev/null 2>&1; then
		pdftoppm -png -f 1 -l 1 -scale-to-x "$PV_WIDTH" -scale-to-y "$PV_HEIGHT" \
			-- "$FILE_PATH" "${IMAGE_CACHE_PATH%.*}" && exit 6
	fi
	exit 1
	;;
application/zip | application/gzip | application/x-bzip2 | application/x-xz | application/x-tar | application/x-7z-compressed | application/x-rar)
	if command -v bsdtar >/dev/null 2>&1; then
		bsdtar -tf -- "$FILE_PATH" | head -n "$PV_HEIGHT"
	elif command -v atool >/dev/null 2>&1; then
		atool --list -- "$FILE_PATH" | head -n "$PV_HEIGHT"
	else
		exit 1
	fi
	exit 0
	;;
audio/* | video/*)
	if command -v mediainfo >/dev/null 2>&1; then
		mediainfo -- "$FILE_PATH"
	elif command -v ffprobe >/dev/null 2>&1; then
		ffprobe -hide_banner -- "$FILE_PATH" 2>&1 | head -n "$PV_HEIGHT"
	else
		exit 1
	fi
	exit 0
	;;
esac

# fallback: let ranger show plain text content itself, otherwise no preview
if [ "$mime" = "text/plain" ]; then
	exit 2
fi
exit 1
