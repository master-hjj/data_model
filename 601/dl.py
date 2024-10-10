from minio import Minio, S3Error
client = Minio(
    '43.143.230.183:9350',
    access_key='JbYs2023',
    secret_key='JbYs@6F9T8_431-Y7',
    secure=False  # 如果使用 HTTPS 连接，请将 secure 设置为 True
)
buckets = client.list_buckets()
for bucket in buckets:
    print(bucket.name, bucket.creation_date)
bucket_name = 'models'
objects = client.list_objects(bucket_name)
for obj in objects:
    print(obj.object_name, obj.last_modified, obj.size)
object_name = 'models/cnn.py'
local_file_path = 'C:\\Users\\m1980\\Desktop\\buct-kaggle\\data_model\\601\\m.py'

try:
    client.fget_object(bucket_name, object_name, local_file_path)
    print(f'Successfully downloaded {object_name} to {local_file_path}')
except S3Error as err:
    print(f'Error occurred: {err}')