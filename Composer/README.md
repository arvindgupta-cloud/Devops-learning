# [Cloud-composer](https://docs.cloud.google.com/composer/docs/composer-3/composer-overview)

**Cloud-composer** - It is **Fully managed workflow orchestration service** built on **Apache Airflow**. It allows you to create, schedule, and monitor **data pipelines** in Google CLoud.


**Apache Airflow** -  An open-source tool to schedule, monitor and manage workflows. Also help in automating data pipelines efficiently.

**Why Use Airflow?**
- Automate and schedule tasks
- Monitors workflows visually
- Handles dependencies between task.
- Scales esaily for large data workflows.

**How Does It works?**
- **DAG (Directed Acyclic Graph)** -> Define the workflow.
- **Tasks** -> Each step in the workflow (e.g. extract, transform, load)
- **Schedular** -> Triggers workflows based on the time or events.
- **Executor** -> Runs the tasks (Local, Celery, Kubernetes)
- **Web UI** -> Provides a dashboard to monitor workflows.

---

**Write Simple DAG with multi-task**

```
import datetime

from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.operators.python import PythonOperator


def hello_world1():
    print("Hello World from task1")
    
def hello_world2():
    print("Hello World from task 2")
    
def hello_world3():
    print("Hello World from task 3")
    

default_args = {
    'start_date': datetime.datetime(2000, 1, 1),
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
}

dag = DAG(
    'basic_dag_with_dependency',
    default_args=default_args,
    description='Basic Dag',
    max_active_runs=2,
    schedule=None,
    catchup=False,
    dagrun_timeout=datetime.timedelta(minutes=10),
)

# priority_weight has type int in Airflow DB, uses the maximum.
bash_operator = BashOperator(
    task_id='task1',
    bash_command='echo test',
    dag=dag,
    )

python_operator1 = PythonOperator(
    task_id='task2',
    python_callable=hello_world1,
    dag=dag,
)
python_operator2 = PythonOperator(
    task_id='task3',
    python_callable=hello_world2,
    dag=dag,
)
python_operator3 = PythonOperator(
    task_id='task4',
    python_callable=hello_world3,
    dag=dag,
)


bash_operator >> [python_operator1, python_operator2] >>  python_operator3
```

**Output:**

<img width="760" height="282" alt="image" src="https://github.com/user-attachments/assets/250564d9-ec00-41d6-ade4-b3aea07cb1d8" />

---

**Create an Apache Airflow DAG pipeline to load GCS data into a Google BigQuery table**

```
import datetime

from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator

default_args = {
    'start_date': datetime.datetime(2000, 1, 1),
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
}

dag = DAG(
    'gcs_to_bq_pipelines',
    default_args=default_args,
    description='Basic Dag',
    max_active_runs=2,
    schedule=None,
    catchup=False,
    dagrun_timeout=datetime.timedelta(minutes=10),
)

# priority_weight has type int in Airflow DB, uses the maximum.
load_csv = GCSToBigQueryOperator(
    task_id='load_csv',
    bucket='newfile-112',
    source_objects=['employee.csv'],
    destination_project_dataset_table='qwiklabs-gcp-03-039a5b72a35d.my_dataset.employee_data',
    source_format='CSV',
    skip_leading_rows=1,
    write_disposition='WRITE_TRUNCATE',
    autodetect=True,
    dag=dag,
)

load_csv
```


**Output:**

<img width="1917" height="957" alt="image" src="https://github.com/user-attachments/assets/2ece8260-52cf-4567-b4a8-5353ab555062" />


<img width="1917" height="873" alt="image" src="https://github.com/user-attachments/assets/58098bf0-4ab4-44ec-acdc-2bce16cf137f" />


---

**Check the CSV file exist in the GCS or not in Airflow Sensor**

```
import datetime

from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.google.cloud.sensors.gcs import GCSObjectExistenceSensor

default_args = {
    'start_date': datetime.datetime(2000, 1, 1),
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
}

dag = DAG(
    'gcs_to_bq_pipelines',
    default_args=default_args,
    description='Basic Dag',
    max_active_runs=2,
    schedule=None,
    catchup=False,
    dagrun_timeout=datetime.timedelta(minutes=10),
)


check_file= GCSObjectExistenceSensor(
    task_id='check_file',
    bucket='newfile-112',
    object='employee.csv',
    timeout=600,
    poke_interval=10,
    dag=dag,
    
)

# priority_weight has type int in Airflow DB, uses the maximum.
load_csv = GCSToBigQueryOperator(
    task_id='load_csv',
    bucket='newfile-112',
    source_objects=['employee.csv'],
    destination_project_dataset_table='qwiklabs-gcp-03-039a5b72a35d.my_dataset.employee_data',
    source_format='CSV',
    skip_leading_rows=1,
    write_disposition='WRITE_TRUNCATE',
    autodetect=True,
    dag=dag,
)

check_file >> load_csv
```

---

**Move a GCS file from another Folder using Airflow Pipeline DAG**

```
import datetime

from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.google.cloud.sensors.gcs import GCSObjectExistenceSensor
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator

default_args = {
    'start_date': datetime.datetime(2000, 1, 1),
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
}

dag = DAG(
    'gcs_to_bq_pipelines',
    default_args=default_args,
    description='Basic Dag',
    max_active_runs=2,
    schedule=None,
    catchup=False,
    dagrun_timeout=datetime.timedelta(minutes=10),
)


check_file= GCSObjectExistenceSensor(
    task_id='check_file',
    bucket='newfile-112',
    object='employee.csv',
    timeout=600,
    poke_interval=10,
    dag=dag,
    
)

# priority_weight has type int in Airflow DB, uses the maximum.
load_csv = GCSToBigQueryOperator(
    task_id='load_csv',
    bucket='newfile-112',
    source_objects=['employee.csv'],
    destination_project_dataset_table='qwiklabs-gcp-03-039a5b72a35d.my_dataset.employee_data',
    source_format='CSV',
    skip_leading_rows=1,
    write_disposition='WRITE_TRUNCATE',
    autodetect=True,
    dag=dag,
)

move_file = GCSToGCSOperator(
    task_id='move_file',
    source_bucket='newfile-112',
    source_object='employee.csv',
    destination_bucket='newfile-112',
    destination_object='processed/employee.csv',
    move_object=True,
    dag=dag,
    
)

check_file >> load_csv >> move_file
```

---
