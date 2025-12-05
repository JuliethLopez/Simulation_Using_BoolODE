import pandas as pd
from sklearn.manifold import TSNE
import matplotlib
import matplotlib.pyplot as plt

def vis(df, p):
    tsne = TSNE(n_components=2,perplexity=p).fit_transform(df.T.values) #perplexity: how to balance attention between local and global aspects. More or less a guess about the number of close neighbors each point has.
    tdf = pd.DataFrame(tsne, columns=['t-SNE 1', 't-SNE 2'],index=df.columns)
    tdf.to_csv('test_1000cells_5times/tsne.csv')
    fig, ax = plt.subplots(1,1,figsize=(5,5))
    ax.scatter(tsne[:,0], tsne[:,1], c = [float(col.split('_')[1]) for col in df.columns])
    ax.axis('off')
    plt.tight_layout()
    plt.savefig('test_1000cells_10times/tree.png')

df=pd.read_csv('test_1000cells_10times/ExpressionData.csv', index_col=0)
vis(df, 400)