with dim_occupation as (select * from {{ ref('dim_occupation') }})

select
    occupation_id,
    occupation,
    occupation_group,
    occupation_field
from dim_occupation
group by 