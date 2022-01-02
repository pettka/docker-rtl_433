# rtl_433

Inspired by this project [hertzg/rtl_433](https://github.com/hertzg/rtl_433_docker), but it uses a custom **rtl_433** [build](https://github.com/merbanan/rtl_433/issues/1569#issuecomment-740186792) with an availability of using secured connection to InfluxDB.
Before app build it replaces a line in the file `src/CMakeLists.txt`:
```
target_link_libraries(rtl_433 r_433)
=>
target_link_libraries(rtl_433 r_433 ssl crypto)
```


# Usage

Download and save the Dockerfile file locally and run a docker command to build app and image:
```
docker build -t rtl_433 .
```

Start container that will send data to TLS secured InfluxDB that runs like https://example.com:8086
```
docker run -d --restart always --device /dev/bus/usb/001/002 --name rtl_433 rtl_433 -C si -F "influxs://example.com:8086/api/v2/write?org=organization&bucket
=rtl433,token=secretToken"
```

# Docker Hub

The docker image is also available on [Docker Hub](https://hub.docker.com/r/pettka/rtl_433) `pettka/rtl_433`.
