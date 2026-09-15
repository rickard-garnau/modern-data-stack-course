import requests
from pathlib import Path
import os
import dlt
import json

working_directory = Path(__file__).parent
os.chdir(working_directory)

API_KEY = dlt.secrets["apiKey"]
url = f"https://openparking.stockholm.se/LTF-Tolken/v1/servicedagar/all?outputFormat=json&apiKey={API_KEY}"

def get_service_days(url, params=None):
    response = requests.get(url, params=params)
    response.raise_for_status()
    return response.json()

@dlt.resource(write_disposition="replace")
def view_days():
    data = get_service_days(url)
    for day in data["features"]:
        yield day


if __name__ == "__main__":
    pipeline = dlt.pipeline(
        pipeline_name="parking_info",
        destination="snowflake",
        dataset_name="staging"
    )
    load_info = pipeline.run(view_days(), table_name="service_days")
    print(load_info)