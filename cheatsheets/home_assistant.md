# HOME ASSISTANT
- https://www.home-assistant.io/
- https://developers.home-assistant.io/
- glossary of terms: https://www.home-assistant.io/docs/glossary/

## ARCHITECTURE
- https://developers.home-assistant.io/docs/architecture_index/
- home assistant OS (formerly HassOS) - linux based OS from [buildroot](https://buildroot.org/), with add-ons
- home assistant supervisor - program that manages/upgrades home assistant OS and home assistant core
    - add-ons are created in new containers
- home assitant core - the main backend brains
- uses a SQLite db, generally located at `config/home-assistant_v2.db`

## AUTOMATIONS
- multiple triggers are OR'd together

## CONFIGURATION
- https://www.home-assistant.io/docs/configuration/
- after manually editting it, highly rec'd to validate the configuration file, then restart
- for template sensors, after editting configuration.yml, goto developer tools and reload just templates, don't have to restart HASS
    - this should clear deletedt template sensors from configuration.yml

## SPECIAL TYPES
- templates -> entity whose data is derived from other data
- REST service - REST service: https://www.home-assistant.io/integrations/rest/ , create sensor for REST API response
    - not be confused with REST command: https://www.home-assistant.io/integrations/rest_command/
        - this is a service type that just fires off a HTTP request somewhere (ignores response i suppose)
    - the inverse is template webhook: https://www.home-assistant.io/docs/automation/trigger/#webhook-trigger
        - client pushes data to HASS and you can create a entity/sensor from that data

## API
- REST API docs: https://developers.home-assistant.io/docs/api/rest
- `curl http://192.168.1.1/api/`
- calling a webhook
    - `xh -v http://127.0.0.1:8123/api/webhook/webhook_id --auth-type bearer --auth sometokenvalue jsonprop1=1 jsonprop2=4`

## CLI
- the official CLI: https://github.com/home-assistant/cli , `ha` bin
    - i think it's only available on the homeassistant OS
- great 3rd party: https://github.com/home-assistant-ecosystem/home-assistant-cli , `hass-cli` bin
    - calling a service
        - `hass-cli service call notify.some_device --arguments message="hi there",title=whatever`
        - `hass-cli service call light.toggle --arguments entity_id=light.some_entity_name`
        - `service call media_player.play_media --arguments entity_id=media_player.spotify_entity,media_content_type=music,media_content_id=https://open.spotify.com/track/1hrRNhEG0ES4OC5rBCU1F8`
    - toggle entity: `hass-cli state toggle someentity`
    - call webhook, `hss raw post --json '{ "prop1" : "value1" }' /api/webhook/somehook`
