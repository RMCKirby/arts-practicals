with Ada.Text_IO; use Ada.Text_IO;
procedure Practical3 is

  numbers : array(1..10) of Integer;

  procedure DoWork is
    task OneWriter;
    task SevenWriter;

    task body OneWriter is
    begin
      Put_Line("Task One Running");
      for n in numbers'Range loop
        numbers(n) := 1;
      end loop;
    end OneWriter;

    task body SevenWriter is
    begin
      Put_Line("Task Seven Running");
      for n in numbers'Range loop
        numbers(n) := 7;
      end loop;
    end SevenWriter;

  begin
    null;
  end DoWork;

begin
  for n in numbers'Range loop
    numbers(n) := 0;
  end loop;

  DoWork;

  for n in numbers'Range loop
    Put_Line(integer'image(numbers(n)));
  end loop;
end Practical3;
