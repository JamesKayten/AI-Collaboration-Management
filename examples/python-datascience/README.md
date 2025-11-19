# Python Data Science Example

Configuration for data science and machine learning projects with Jupyter notebooks, Python, and ML frameworks.

## Tech Stack

- **Language**: Python 3.8+
- **Notebooks**: Jupyter, JupyterLab
- **ML/AI**: TensorFlow, PyTorch, Scikit-learn
- **Data**: Pandas, NumPy
- **Testing**: Pytest
- **Code Quality**: Black, Flake8, MyPy

## Features

This configuration validates:

✅ Notebook organization and size
✅ Model accuracy thresholds
✅ Memory usage limits
✅ Code reproducibility
✅ Documentation quality
✅ Data validation
✅ Test coverage

## Installation

```bash
cd your-data-science-project
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git ../ai-framework
../ai-framework/setup-ai-collaboration.sh
cp ../ai-framework/examples/python-datascience/VALIDATION_RULES.md .ai-framework/rules/
```

## Validation Rules

### Notebook Quality

```yaml
max_cells_per_notebook: 50
max_code_cell_lines: 30
markdown_required: true
clear_outputs_before_commit: true
```

**Why**: Keeps notebooks organized, readable, and version-control friendly.

### Model Performance

```yaml
min_model_accuracy: 0.85
min_validation_score: 0.80
reproducible_results: required
random_seed: required
```

**Why**: Ensures reliable and reproducible ML results.

### Resource Management

```yaml
max_memory_usage: 8GB
max_training_time: 4h
gpu_memory_monitoring: true
data_size_limits: 1GB per file
```

**Why**: Prevents resource exhaustion and long-running jobs.

## Workflow Example

1. **Develop model in notebook**
2. **Run validation**: `"work ready"`
3. **Fix issues**: Address notebook size, add documentation
4. **Export to script**: Convert stable code to .py files
5. **Re-validate**: Ensure scripts pass quality checks

## Customization

Adjust thresholds for your specific use case:
- Research projects: More relaxed on cell counts
- Production ML: Stricter accuracy requirements
- Training pipelines: Higher memory/time limits

---

See `VALIDATION_RULES.md` for complete rules and check commands.
