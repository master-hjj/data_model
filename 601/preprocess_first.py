import pandas as pd
from sklearn.preprocessing import StandardScaler
from io import BytesIO
class Process():

    def __init__(self,name, df):
        self.name = name
        self.df = df

    def run(self):
        # 创建一个 StandardScaler 对象
        scaler = StandardScaler()

        # 对 DataFrame 进行标准化
        df_standardized = pd.DataFrame(scaler.fit_transform(self.df), columns=self.df.columns)

        # 创建一个字节流对象
        output = BytesIO()
        # 将 DataFrame 写入字节流，以 CSV 格式
        df_standardized.to_csv(output, index=False)
        # 将字节流的指针移到开始位置
        output.seek(0)

        # 返回 CSV文件
        return output
