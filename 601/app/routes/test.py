if __name__ == '__main__':
    import pandas as pd
    import importlib
    dataset = pd.read_csv(fr'D:\Users\deeptrain_back\app\model_and_data\datasets\data.csv')
    module_spec = importlib.util.spec_from_file_location('Train_DML', fr'D:\Users\model\app\routes\MLP.py')

    # 步骤2：加载模块
    module = importlib.util.module_from_spec(module_spec)
    module_spec.loader.exec_module(module)

    # 步骤3：获取类对象
    class_obj = getattr(module, 'Train_DML')
    params = {
        'dataset': dataset,
        'model_params': {'input_size': '12', 'output_size': '1', 'hidden_size': '5', 'num_layers': '3', 'learning_rate': '0.01', 'batch_size': '32', 'epochs': '10'},
        'input': ['FCC_TIC1303_PV_csv', 'FCC_PI1301_PV_csv', 'FCC_FIC1311_PV_csv', 'FCC_TIC1402_PV_csv', 'FCC_TIC1402-1_PV_csv', 'FCC_FI1400_PV_csv', 'FCC_FIC1402-1_PV_csv', 'FCC_FVC1402_PV_csv', 'FCC_TI1419_PV_csv', 'FCC_LIC1404_PV_csv', 'FCC_TI1418_PV_csv', 'FCC_PDI1414_PV_csv'],
        'output': ['FCC_TI1418_PV_csv'],
    }

    model_train = class_obj(**params)
    res = model_train.train()
    print(res)
    print("训练结束")