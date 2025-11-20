# Python Data Science - Validation Rules

Validation rules for data science and machine learning projects ensuring reproducibility, quality, and maintainability.

## Notebook Organization

### Cell Count Limit

**Rule**: Notebooks should not exceed 50 cells

**Check Command**:
```bash
for nb in notebooks/*.ipynb; do
  count=$(jq '.cells | length' "$nb")
  if [ $count -gt 50 ]; then
    echo "❌ $nb: $count cells (max 50)"
  fi
done
```

**Severity**: Warning

**Fix Suggestion**: Split large notebooks into focused sections or separate files

### Code Cell Size

**Rule**: Code cells should not exceed 30 lines

**Check Command**:
```bash
python -c "
import json
import sys
for nb_file in sys.argv[1:]:
    with open(nb_file) as f:
        nb = json.load(f)
    for i, cell in enumerate(nb['cells']):
        if cell['cell_type'] == 'code':
            lines = len(cell['source'])
            if lines > 30:
                print(f'❌ {nb_file} cell {i}: {lines} lines (max 30)')
" notebooks/*.ipynb
```

**Severity**: Warning

**Fix Suggestion**: Extract complex logic into Python modules

### Markdown Documentation

**Rule**: Every 5 code cells must have at least 1 markdown cell explaining the logic

**Severity**: Warning

**Fix Suggestion**: Add markdown cells documenting approach, decisions, and findings

## Model Performance

### Accuracy Threshold

**Rule**: Model accuracy must meet minimum threshold (85% for classification, R²>0.80 for regression)

**Check Command**:
```bash
# Extract from notebook output or training logs
python -c "
import json
with open('results/model_metrics.json') as f:
    metrics = json.load(f)
if metrics.get('accuracy', 0) < 0.85:
    print(f\"❌ Accuracy: {metrics['accuracy']:.2%} (min 85%)\")
"
```

**Severity**: Error

**Fix Suggestion**:
- Feature engineering
- Hyperparameter tuning
- Try different algorithms
- Increase training data

### Validation Score

**Rule**: Validation score must be within 5% of training score (detect overfitting)

**Check Command**:
```bash
python scripts/check_overfitting.py
```

**Severity**: Error

**Fix Suggestion**:
- Add regularization
- Reduce model complexity
- Use cross-validation
- Increase training data

## Code Quality

### Black Formatting

**Rule**: All Python code must be formatted with Black

**Check Command**:
```bash
black --check src/ scripts/
```

**Severity**: Error

**Fix Suggestion**: Run `black src/ scripts/`

### Flake8 Compliance

**Rule**: No Flake8 violations

**Check Command**:
```bash
flake8 src/ scripts/ --max-line-length=88 --extend-ignore=E203,W503
```

**Severity**: Warning

**Fix Suggestion**: Fix linting errors

### Type Hints

**Rule**: Functions must have type hints

**Check Command**:
```bash
mypy src/ --strict
```

**Severity**: Warning

**Fix Suggestion**: Add type hints to function signatures

## Reproducibility

### Random Seeds

**Rule**: All random operations must use fixed seeds

**Check Command**:
```bash
grep -r "random\|np.random\|torch.manual_seed\|tf.random.set_seed" notebooks/ src/ | grep -v "seed="
```

**Severity**: Error

**Fix Suggestion**: Set seeds:
```python
import numpy as np
import random
import torch
random.seed(42)
np.random.seed(42)
torch.manual_seed(42)
```

### Requirements File

**Rule**: requirements.txt must be up to date with pinned versions

**Check Command**:
```bash
pip-compile requirements.in --quiet
diff requirements.txt requirements.in
```

**Severity**: Error

**Fix Suggestion**: Run `pip freeze > requirements.txt`

### Environment Documentation

**Rule**: README must document environment setup

**Required Sections**:
- Python version
- System dependencies
- Installation steps
- Data setup

**Severity**: Warning

## Resource Management

### Memory Usage

**Rule**: Scripts must not exceed 8GB RAM

**Check Command**:
```bash
# Monitor during execution
python -m memory_profiler scripts/train_model.py
```

**Severity**: Warning

**Fix Suggestion**:
- Use data generators
- Process in batches
- Optimize data types (float16 instead of float32)

### Training Time

**Rule**: Training should complete within 4 hours

**Severity**: Warning

**Fix Suggestion**:
- Reduce dataset size for development
- Use learning rate schedulers
- Early stopping
- Distributed training

## Data Quality

### Missing Values

**Rule**: Document handling of missing values

**Check Command**:
```bash
python -c "
import pandas as pd
df = pd.read_csv('data/dataset.csv')
missing = df.isnull().sum()
if missing.any():
    print('❌ Missing values found:')
    print(missing[missing > 0])
"
```

**Severity**: Warning

**Fix Suggestion**: Document strategy in notebook

### Data Validation

**Rule**: Input data must pass validation schema

**Check Command**:
```bash
python scripts/validate_data.py data/dataset.csv
```

**Severity**: Error

**Fix Suggestion**: Fix data issues or update schema

## Testing

### Unit Tests

**Rule**: Core functions must have tests (80% coverage)

**Check Command**:
```bash
pytest tests/ --cov=src --cov-report=term --cov-fail-under=80
```

**Severity**: Error

**Fix Suggestion**: Add tests for untested functions

### Data Tests

**Rule**: Test data properties and distributions

**Example Tests**:
- Data shape matches expected
- Value ranges are valid
- No duplicate IDs
- Required columns present

**Severity**: Warning

## Documentation

### Docstrings

**Rule**: All functions must have docstrings

**Check Command**:
```bash
pydocstyle src/ --convention=google
```

**Severity**: Warning

**Fix Suggestion**: Add Google-style docstrings

### Experiment Tracking

**Rule**: All experiments must be logged

**Required Info**:
- Hyperparameters
- Metrics
- Dataset version
- Model architecture
- Training duration

**Tools**: MLflow, Weights & Biases, TensorBoard

**Severity**: Warning

## Notebook Best Practices

### Clear Outputs

**Rule**: Notebooks in version control must have cleared outputs

**Check Command**:
```bash
jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace notebooks/*.ipynb
```

**Severity**: Error

**Fix Suggestion**: Use pre-commit hook to clear outputs

### Import Organization

**Rule**: All imports at the top of notebook

**Severity**: Warning

**Fix Suggestion**: Move imports to first code cell

### Magic Commands

**Rule**: Avoid excessive use of magic commands (%matplotlib, %time, etc.)

**Severity**: Warning

**Fix Suggestion**: Use Python equivalents where possible

## Version Control

### Large Files

**Rule**: No large files (>100MB) in git

**Check Command**:
```bash
find . -type f -size +100M | grep -v ".git"
```

**Severity**: Error

**Fix Suggestion**: Use Git LFS or external storage

### Data Directory

**Rule**: data/ directory must be in .gitignore

**Severity**: Error

**Fix Suggestion**: Add to .gitignore, use DVC for data versioning

---

## Validation Workflow for Data Science

1. **Notebook Development**
   - Write exploratory code
   - Document findings
   - Track experiments

2. **Validation Check**
   - Run all quality checks
   - Verify model performance
   - Check reproducibility

3. **Code Extraction**
   - Move stable code to .py modules
   - Add tests
   - Update documentation

4. **Final Validation**
   - Verify scripts run end-to-end
   - Check resource usage
   - Ensure reproducibility

## Notes for AI

- **Prioritize reproducibility** - ML results must be deterministic
- **Document assumptions** - Explain data preprocessing decisions
- **Track experiments** - Log all hyperparameters and results
- **Optimize iteratively** - Start simple, add complexity gradually
- **Validate data** - Check data quality before training
