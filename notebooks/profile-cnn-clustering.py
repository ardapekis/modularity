import sys
sys.path.append('..')

from src.visualization import draw_mlp_clustering_report, run_double_spectral_cluster
from src.utils import get_weights_paths, build_clustering_results
from src.experiment_tagging import get_model_path, MODEL_TAG_LOOKUP
from src.spectral_cluster_model import SHUFFLE_METHODS
clustering_results = {}
model_tags = list(tag for tag in MODEL_TAG_LOOKUP.keys()
              if 'CNN' in tag)
mlp_model_paths = {model_tag: get_model_path(model_tag) for model_tag in model_tags}
model_name, path = next(iter(mlp_model_paths.items()))
clustering_results[model_name] = {}
shuffle_method = SHUFFLE_METHODS[0]
print(f"model_name={model_name}, path={path}, shuffle_method={shuffle_method}")
clustering_results[model_name][shuffle_method] = run_double_spectral_cluster(path)

