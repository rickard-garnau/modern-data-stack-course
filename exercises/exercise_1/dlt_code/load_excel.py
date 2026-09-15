import dlt
import pandas as pd
from pathlib import Path
import os

@dlt.resource(write_disposition="replace")
def load_excel_resource(file_path: str, **kwargs):
    df = pd.read_excel(file_path, **kwargs)
    yield df

if __name__ == "__main__":
    working_directory = Path(__file__).parent
    data_directory = working_directory.parent / "data"

    os.chdir(working_directory)
    excel_path = data_directory / "iFood.xlsx"

    data = load_excel_resource(excel_path)

    pipeline = dlt.pipeline(
        pipeline_name="ifood", destination="snowflake", dataset_name="staging"
    )
    load_info = pipeline.run(data, table_name="ifood")

    print(load_info)