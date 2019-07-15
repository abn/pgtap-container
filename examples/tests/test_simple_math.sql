-- Start transaction and plan the tests.
BEGIN;
SELECT plan(1);

SELECT is(1 + 1, 2, 'This is not math');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;