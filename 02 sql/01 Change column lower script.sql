/**
  * Description：Change column lower
  * Author: @24Arise
  * Date: 2023.03.06 17:00:00
 */
select concat('alter table '
           , table_name
           , ' change column '
           , column_name
           , ' '
           , lower(column_name)
           , ' '
           , column_type
           , ' '
           , case
                 when IS_NULLABLE = 'YES' THEN
                     'null'
                 else
                     'not null'
                  end
           , ' comment '''
           , column_comment
           , ''';') as 'Change column lower'
from information_schema.columns
where table_schema = 'hfins_base'
  and table_name not in ('databasechangelog', 'databasechangeloglock', 'himp_data', 'himp_import')
  and column_name REGEXP BINARY '[A-Z]';

/**
  * Description：Change table lower
  * Author: @24Arise
  * Date: 2023.03.06 17:00:00
 */
select concat('rename table ', t.table_schema, '.', t.table_name, ' to ', lower(t.table_name),
              ';') as 'Change table lower'
from information_schema.tables t
where t.table_schema = 'hfins_base_account'
  and table_name regexp binary '[A-Z]';

/**
  * Description：Change index lower
  * Author: @24Arise
  * Date: 2023.03.06 17:00:00
 */
select concat('drop index ', index_name, ' on ', table_schema, '.', table_Name, ';', ' create index ',
              lower(index_name),
              ' on ', table_schema, '.', table_name, '(', (select group_concat(column_name)
                                                           from information_schema.statistics
                                                           where table_schema = iss.table_schema
                                                             and table_name = iss.table_name
                                                             and index_name != 'PRIMARY'
                                                             and index_name = iss.index_name),
              ');') as 'Change index lower'
from information_schema.statistics iss
where iss.table_schema = 'hfins'
  and iss.index_name regexp binary '[A-Z]'
  and iss.index_name != 'PRIMARY';
