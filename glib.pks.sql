create or package body glib as

    procedure add_partitions(i_owner varchar2, i_table_name varchar2) is
        v_partition_name varchar2(10);
    begin
        select min(partition_name) into v_partition_name
        from
            all_tab_partitions
        where
            table_owner = i_owner and table_name = i_table_name;

        if length(v_partition_name) = 3 then
            add_monthly_partitions(i_owner, i_table_name);
        elsif length(v_partition_name) = 5 then
            add_daily_partitions(i_owner, i_table_name);
        else
            raise 'Partition type not supported!';
        end;
    end;

    procedure add_monthly_partitions(i_owner varchar2, i_table_name varchar2) is
        v_date date := to_date('20200101', 'yyyymmdd');
    begin
        loop
            begin
                execute immediate 'alter table '|| i_owner ||'.'|| i_table_name ||'
                    add partition '||to_char(v_date, 'ymm')||' values ('''||to_char(v_date, 'ymm')||''')
                ';
            exception when others
                null;
            end;
            v_date := add_months(v_date, 1);
            exit when v_date >= to_date('20300101', 'yyyymmdd');
        end loop;

    end;

    procedure add_daily_partitions(i_owner varchar2, i_table_name varchar2) is
        v_date date := to_date('20200101', 'yyyymmdd');
    begin
        loop
            begin
                execute immediate 'alter table '|| i_owner ||'.'|| i_table_name ||'
                    add partition '||to_char(v_date, 'ymmdd')||' values ('''||to_char(v_date, 'ymmdd')||''')
                ';
            exception when others
                null;
            end;
            v_date := v_date + 1 ;
            exit when v_date >= to_date('20300101', 'yyyymmdd');
        end loop;

    end;



end;