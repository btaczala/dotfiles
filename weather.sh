# User configurables below:
# Uncomment this line for fahrenheit:
#metric='imperial' && unit='F'
# Otherwise comment above line, uncomment here for celcius:
metric='metric' && unit='C'

# First, geolocate our IP:
ipinfo=$(curl -s ipinfo.io)
latlong=$(echo $ipinfo | jq -r '.loc')
# Parse the latitude and longitude into their own values
lat=44.83
long=11.61

weather=$(curl -s http://api.openweathermap.org/data/2.5/weather\?id=3083829&units=metric)
city=$(echo $weather | jq -r '.name')
temperature=$(printf '%.0f' $(echo $weather | jq '.main.temp'))
condition=$(echo $weather | jq -r '.weather[0].main')
temperature=`expr $temperature - 270`

echo -n "$condition: "
echo $temperature °$unit
