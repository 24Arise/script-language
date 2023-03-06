/**
  * Description: Setting sequence max value
  * Author: 24Arise
  * Date: 2018/07/06 13:59
 */
declare
    -- 游标【表名】
    cursor cur_tbl is
        select ut.table_name
        from user_tables ut
        order by ut.table_name;

    -- 参数
    v_sequence  varchar2(255);
    v_max_sql   varchar2(255);
    v_increment number := 1; -- 步长 [HEC4.0 的所有序列默认步长为 1]
    v_number    number; -- 从多少开始
    v_next      number; -- 下一个值
begin
    for csr_tbl in cur_tbl
        loop
            begin
                -- 1.0 获取序列名称
                v_sequence := csr_tbl.table_name || '_S';
                -- 2.0 获取表主键对应的字段的最大值
                select 'select nvl(max(' || ucc.column_name || '),0) from ' || uc.table_name
                into v_max_sql
                from user_constraints uc,
                     user_cons_columns ucc
                where uc.constraint_type = 'P'
                  and uc.constraint_name = ucc.constraint_name
                  and uc.table_name = ucc.table_name
                  and uc.table_name = csr_tbl.table_name;
                -- 3.0 执行
                execute immediate v_max_sql
                    into v_number;
                -- 4.0 从 最大值 + 1 开始
                v_number := v_number + 1;
                -- execute immediate 'create sequence ' || v_sequence || ' start with ' || v_number;
                -- 5.0 获取下一个值
                execute immediate 'select ' || v_sequence || '.nextval from dual'
                    into v_next;
                -- 6.0 计算序列的步长
                v_next := v_number - v_next - v_increment;
                -- 7.0 调整序列的步长
                execute immediate 'alter sequence ' || v_sequence || ' increment by ' ||
                                  v_next;
                -- 8.0 重新获取下一个值
                execute immediate 'select ' || v_sequence || '.nextval from dual'
                    into v_next;
                -- 9.0 还原原序列的步长
                execute immediate 'alter sequence ' || v_sequence || ' increment by ' ||
                                  v_increment;
            exception
                when others then
                    dbms_output.put_line(a => csr_tbl.table_name ||
                                              dbms_utility.format_error_backtrace || ' ' ||
                                              sqlerrm);
            end;
        end loop;
end;
