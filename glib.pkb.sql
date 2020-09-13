create or package glib authid current_user as
    procedure add_partitions(i_owner varchar2, i_table_name varchar2);
end;