# CSV Export

Generates two CSVs from the JSON data files for team review.

## Usage

```bash
python3 scripts/generate_test_csv.py
```

## Output

| File | Rows | Contents |
|---|---|---|
| `~/Downloads/test_data_published.csv` | 18 | Published tests — all columns filled |
| `~/Downloads/test_data_upcoming.csv` | 10 | Upcoming tests — `about`, `author_*`, `adapter_*` empty, ready to fill |

UTF-8-BOM (Excel/Google Sheets compatible).

## Columns (both files)

| Column | Published source | Upcoming source |
|---|---|---|
| `id` | test JSON `id` | manifest `id` |
| `name` | test JSON `name` | manifest `name` |
| `description` | `tests_manifest.json` | manifest `description` |
| `about` | test JSON `about` | *(empty)* |
| `category` | `tests_manifest.json` | manifest `category` |
| `question_count` | `tests_manifest.json` | manifest `questionCount` |
| `estimated_time_min` | `tests_manifest.json` | manifest `estimatedTimeMinutes` |
| `sensitivity_level` | `tests_manifest.json` | manifest `sensitivityLevel` |
| `reliability_badge` | `tests_manifest.json` | manifest `reliabilityBadge` |
| `author_citation` | test JSON `author[*].citation` | *(empty)* |
| `author_url` | test JSON `author[*].url` | *(empty)* |
| `adapter_citation` | test JSON `adapter[*].citation` | *(empty)* |
| `adapter_url` | test JSON `adapter[*].url` | *(empty)* |
| `bangla_version_url` | test JSON → `resources` | manifest → `resources` |
| `bangla_version_scoring_url` | test JSON → `resources` | manifest → `resources` |
| `bangla_version_doi` | test JSON → `resources` | manifest → `resources` |

## What's excluded

`instruction`, `scales`, `options`, `questions`, `resultBands`, `scoringProcedure`, `lucideIconName`, `themeColor`.

## Adding a new test

### Published
1. Create `assets/data/<id>_bn.json`
2. Add entry to `assets/data/tests_manifest.json`
3. Re-run script

### Upcoming
1. Add entry to `assets/data/upcoming/upcoming_manifest.json`
2. Re-run script
