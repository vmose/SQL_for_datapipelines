MERGE `prod.users` T
USING `staging.users_updates` S
ON T.user_id = CAST(S.user_id AS INT64)

-- 1. UPDATE existing users
WHEN MATCHED THEN
  UPDATE SET
    T.full_name = UPPER(COALESCE(S.full_name, T.full_name)),
    T.email = COALESCE(S.email, T.email),
    T.signup_date = COALESCE(
        PARSE_DATE('%Y/%m/%d', S.signup_date),
        T.signup_date
    ),
    T.status = CASE
                 WHEN S.status IS NULL THEN T.status
                 ELSE UPPER(S.status)
               END

-- 2. INSERT new users (with type casting and transformations)
WHEN NOT MATCHED BY TARGET THEN
  INSERT (user_id, full_name, email, signup_date, status)
  VALUES (
    CAST(S.user_id AS INT64),
    UPPER(S.full_name),
    S.email,
    PARSE_DATE('%Y/%m/%d', S.signup_date),
    COALESCE(UPPER(S.status), 'PENDING')
  )

-- 3. Deactivate users missing from source
WHEN NOT MATCHED BY SOURCE AND T.status = 'ACTIVE' THEN
  UPDATE SET
    T.status = 'INACTIVE';
