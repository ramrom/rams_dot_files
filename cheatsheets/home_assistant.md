# HOME ASSISTANT
- https://www.home-assistant.io/
- https://developers.home-assistant.io/

## ARCHITECTURE
- home assistant OS (formerly HassOS) - linux based OS from [buildroot](https://buildroot.org/), with add-ons
- home assistant supervisor - program that manages/upgrades home assistant OS and home assistant core
    - add-ons are created in new containers
- home assitant core - the main backend brains

## API
- `curl http://192.168.1.1/api/`

## CLI
- the official CLI: https://github.com/home-assistant/cli , `ha` bin
    - i think it's only available on the homeassistant OS
- great 3rd party: https://github.com/home-assistant-ecosystem/home-assistant-cli , `hass-cli` bin
