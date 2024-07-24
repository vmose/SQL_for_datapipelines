WITH RECURSIVE CommitHistory AS (
  SELECT
    repo_name,
    commit,
    parent[OFFSET(0)] AS parent_commit,
    author.name AS author_name,
    committer.name AS committer_name,
    committer.date AS committer_date
  FROM
    `bigquery-public-data.github_repos.sample_commits`
  WHERE
    ARRAY_LENGTH(parent) = 0

  UNION ALL

  SELECT
    c.repo_name,
    c.commit,
    c.parent[OFFSET(0)] AS parent_commit,
    c.author.name AS author_name,
    c.committer.name AS committer_name,
    c.committer.date AS committer_date
  FROM
    `bigquery-public-data.github_repos.sample_commits` c
  JOIN
    CommitHistory ch
  ON
    c.commit = ch.parent_commit
)
SELECT
  *
FROM
  CommitHistory;

