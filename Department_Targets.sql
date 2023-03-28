SELECT 
    emp.first_name, 
    emp.last_name, 
    emp.sales, 
    dep.department_name, 
    DENSE_RANK() OVER (
        PARTITION BY dep.department_id 
        ORDER BY emp.sales DESC
    ) AS sales_rank
FROM 
    employees emp
    JOIN departments dep ON emp.department_id = dep.department_id
ORDER BY 
    dep.department_name, 
    sales_rank;
