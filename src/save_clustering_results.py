import pandas as pd
import argparse
from pathlib import Path

from .visualization import run_double_spectral_cluster
from .utils import build_clustering_results
from .experiment_tagging import get_model_path, MODEL_TAG_LOOKUP
from .spectral_cluster_model import SHUFFLE_METHODS

if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("tag", type=str)
    parser.add_argument("path", type=Path)
    
    args = parser.parse_args()
    model_tag = args.tag
    path = args.path
    
    clustering_results = {}

    for shuffle_method in SHUFFLE_METHODS:
        clustering_results[shuffle_method] = run_double_spectral_cluster(path, shuffle_method=shuffle_method)
    clustering_results = {model_tag: clustering_results}
    results = build_clustering_results(clustering_results)
    results.to_csv(path / (model_tag + ".csv"))
