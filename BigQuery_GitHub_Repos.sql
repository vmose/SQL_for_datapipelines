WITH RECURSIVE CommitHistory AS (
    SELECT 
        repo_name,
        sha AS commit_sha,
        NULL AS parent_commit_sha,
        author.name AS author_name,
        committer.name AS committer_name,
        committed_date
    FROM 
        `bigquery-public-data.github_repos.commits`
    WHERE 
        parent IS NULL
    LIMIT 1

    UNION ALL

    SELECT 
        c.repo_name,
        c.sha AS commit_sha,
        c.parent[OFFSET(0)] AS parent_commit_sha,
        c.author.name AS author_name,
        c.committer.name AS committer_name,
        c.committed_date
    FROM 
        `bigquery-public-data.github_repos.commits` c
    JOIN 
        CommitHistory ch
    ON 
        c.sha = ch.parent_commit_sha
)
SELECT 
    * 
FROM 
    CommitHistory;
