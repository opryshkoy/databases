
-- 2.1

SELECT

Department.id,

Department.name,

COUNT (chief_doc_id) as doc

FROM public.Department

JOIN public.Employee

ON Department.id=Employee.department_id

GROUP BY Department.id;


-- 2.2

SELECT

Department.id,

Department.name,

COUNT (chief_doc_id) as doc

FROM public.Department

JOIN public.Employee

ON Department.id=Employee.department_id

GROUP BY Department.id

HAVING COUNT (chief_doc_id) >= 3;


--2.3

WITH dep_public

AS (

SELECT

Department.id,

Department.name,

SUM (num_public) as num_public

FROM public.Department

JOIN public.Employee

ON Department.id=Employee.department_id

GROUP BY Department.id, Department.name

ORDER BY num_public DESC
)

SELECT *

FROM dep_public

WHERE num_public IN (

SELECT num_public

FROM dep_public

LIMIT 1);


--2.4 

WITH doc_public

AS (

SELECT

name,

num_public,

e.department_id

FROM Employee e

JOIN (

SELECT department_id, min (num_public) as min_public

FROM Employee e2

group by department_id) d

on d.department_id=e.department_id

WHERE e.num_public = d.min_public

)

SELECT *

FROM doc_public

JOIN public.Department

ON doc_public.department_id=Department.id;



--2.5

SELECT

Department.id,

Department.name,

AVG (num_public) as avg_public,

COUNT (chief_doc_id) as count_chief_doc

FROM public.Department

JOIN public.Employee

ON Department.id=Employee.department_id

GROUP BY Department.id, Department.name

HAVING Department.id IN (

SELECT department_id

FROM Employee

GROUP BY department_id

HAVING COUNT (chief_doc_id) > 1

);




























