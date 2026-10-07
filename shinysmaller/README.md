# SMALLER shiny app

This contains the configuration for running the SMALLER shiny app within a docker container on the research-main server. It will be available on port 8086.

## Installation

**Note**: This should be done before running the docker compose services.

From within the folder containing the shiny appliations, clone the [SMALLER-shiny](https://github.com/Pivot-Madagascar/SMALLER-shiny) repo into `shinysmaller/SMALLER-shiny`:

```
git clone https://github.com/Pivot-Madagascar/SMALLER-shiny.git shinysmaller/SMALLER-shiny
#create specific files for this workflow for cache and automatic restart of shiny process
mkdir -p shinysmaller/SMALLER-shiny/app_cache
echo "app_cache/" >> shinysmaller/SMALLER-shiny/.git/info/exclude   
echo "restart.txt" >> shinysmaller/SMALLER-shiny/.git/info/exclude
```

This does create a kind of crazy nestedness of github repos and could be better managed by manually updating the files via ssh file copying, but leaving for now because I like to live on the edge.

### Tests

A test file `test_smaller.sh` contains tests that ensure the server is up and running and that the architecture for monthly updates functions properly. It can be run via:

```
bash ./test_smaller.sh
```

## Monthly Updates

This directory is mounted into the docker container, so there is no need to rebuild it for monthly updates. Just pull and trigger a process restart via `restart.txt`.

```
git -C shinysmaller/SMALLER-shiny pull
touch shinysmaller/SMALLER-shiny/restart.txt
```

If this doesn't seem to update it, you can also stop and restart that specific service. But this should only be done by the server admin.

