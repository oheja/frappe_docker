# Run all Grading Record tests
docker compose -p frappe exec -T backend  bench --site localhost run-tests --doctype "Grading Record"

# Run with verbose output
docker compose -p frappe exec -T backend  bench --site localhost run-tests --doctype "Grading Record" --verbose

# Run specific test
docker compose -p frappe exec -T backend  bench --site localhost run-tests --doctype "Grading Record" --test test_happy_path_no_variance_no_discards