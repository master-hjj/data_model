import numpy as np
from sklearn import metrics
from sklearn.preprocessing import MinMaxScaler

def mae(y_true, y_pred):
    return metrics.mean_absolute_error(y_true, y_pred)



def mape(y_true, y_pred):
    l = len(y_true)
    sum = 0.0
    for i in range(l):
        if y_true[i] == 0.:
            l-=1
            continue
        else:
            sum += np.abs((y_pred[i] - y_true[i]) / y_true[i])
    return sum[0]/l
    # return np.mean(np.abs((y_pred - y_true) / y_true))



def mse(y_true, y_pred):
    return metrics.mean_squared_error(y_true, y_pred)


def rmse(y_true, y_pred):
    return np.sqrt(mse(y_true, y_pred))


def msle(y_true, y_pred):
    return metrics.mean_squared_log_error(y_true, y_pred)


def medae(y_true, y_pred):
    return metrics.median_absolute_error(y_true, y_pred)


def r2(y_true, y_pred):
    return metrics.r2_score(y_true, y_pred)


def rae(y_true, y_pred, data_rae):
    return np.sum(np.abs(y_true - y_pred)) / data_rae


def rse(y_true, y_pred, data_rse):
    return np.sum(np.abs(y_true - y_pred) ** 2) / data_rse


def corr(y_true, y_pred):
    std_t = np.std(y_true)
    std_p = np.std(y_pred)
    mean_t = np.mean(y_true)
    mean_p = np.mean(y_pred)
    return np.mean(np.mean((y_true - mean_t) * (y_pred - mean_p)) / (std_t * std_p))


def q_risk(y_true, y_pred, q=0.5):
    zeros = np.zeros(y_true.shape)
    ql = (1 - q) * np.max(np.stack([zeros, y_pred - y_true]), axis=0) + q * np.max(np.stack([zeros, y_true - y_pred]), axis=0)
    return 2 * np.sum(ql) / np.sum(np.abs(y_true))


def evaluate(y_true, y_pred, criterion, dataset):
    y_true, y_pred = np.array(y_true).reshape(-1, 1), np.array(y_pred).reshape(-1, 1)
    orig_y_true, orig_y_pred = dataset.inverse_transform(y_true), dataset.inverse_transform(y_pred)
    y_true, y_pred = MinMaxScaler().fit_transform(y_true), MinMaxScaler().fit_transform(y_pred)

    metrics = {}
    for c in criterion:
        if c == 'rae':
            metrics['rae'] = rae(y_true, y_pred, dataset.rae)
        elif c == 'rse':
            metrics['rse'] = rse(y_true, y_pred, dataset.rse)
        elif c == 'q_risk':
            metrics['P10'] = q_risk(y_true, y_pred, 0.1)
            metrics['P50'] = q_risk(y_true, y_pred, 0.5)
            metrics['P90'] = q_risk(y_true, y_pred, 0.9)
        elif c == 'mape':
            metrics['mape'] = mape(orig_y_true, orig_y_pred)
        else:
            metrics[c] = eval(c)(y_true, y_pred)

    return metrics


# 常用的评估函数
def Eva_Min(y_true, y_pred):
    metrics = {}
    metrics['mae'] = mae(y_true, y_pred)
    metrics['rmse'] = rmse(y_true, y_pred)
    metrics['mape'] = mape(y_true, y_pred)
    metrics['r2'] = r2(y_true, y_pred)
    metrics['mse'] = mse(y_true, y_pred)
    return metrics


if __name__ == '__main__':
    yy_true = np.array([3, -0.5, 2, 7])
    yy_pred = np.array([2.5, 0.0, 2, 8])

    criterion = ['rae', 'rse', 'corr', 'mae', 'rmse', 'mape', 'r2', 'q_risk']

    class YYDataset:
        rae = np.sum(np.abs(yy_true - np.mean(yy_true)))
        rse = np.sum((yy_true - np.mean(yy_true)) ** 2)

        @staticmethod
        def inverse_transform(y):
            return y

    print(evaluate(yy_true, yy_pred, criterion, YYDataset))
