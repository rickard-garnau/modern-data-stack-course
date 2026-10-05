import dlt
import requests
import json

dlt.config["load.truncate_staging_dataset"] = True

params = {"limit": 100, "occupation-field": "6Hq3_tKo_V57"}

def _get_ads(url_for_search, params):
    headers = {"accept": "application/json"}
    response = requests.get(url_for_search, headers=headers, params=params)
    response.raise_for_status()  # check for http errors
    return json.loads(response.content.decode("utf8"))


@dlt.resource(table_name = "job_ads", write_disposition="replace")
def jobads_resource(params):

    url = "https://jobsearch.api.jobtechdev.se"
    url_for_search = f"{url}/search"

    for ad in _get_ads(url_for_search, params)["hits"]:
        yield ad

# dagster works with dlt source not dlt resource
@dlt.source
def jobads_source():
    return jobads_resource(params)