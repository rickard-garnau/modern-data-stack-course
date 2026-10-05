with relation_columns as (

        
        select
            cast('OCCUPATION_ID' as TEXT) as relation_column,
            cast('VARCHAR' as TEXT) as relation_column_type
        union all
        
        select
            cast('EMPLOYER_ID' as TEXT) as relation_column,
            cast('VARCHAR' as TEXT) as relation_column_type
        union all
        
        select
            cast('JOB_DETAILS_ID' as TEXT) as relation_column,
            cast('VARCHAR' as TEXT) as relation_column_type
        union all
        
        select
            cast('AUXILLIARY_ATTRIBUTES_ID' as TEXT) as relation_column,
            cast('VARCHAR' as TEXT) as relation_column_type
        union all
        
        select
            cast('VACANCIES' as TEXT) as relation_column,
            cast('NUMBER' as TEXT) as relation_column_type
        union all
        
        select
            cast('RELEVANCE' as TEXT) as relation_column,
            cast('FLOAT' as TEXT) as relation_column_type
        union all
        
        select
            cast('APPLICATION_DEADLINE' as TEXT) as relation_column,
            cast('TIMESTAMP_TZ' as TEXT) as relation_column_type
        
        
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = 'VACANCIES'
            and
            relation_column_type not in ('NUMBER')

    )
    select *
    from test_data