with Ada.Text_IO; use Ada.Text_IO;
procedure Practical4 is

  numbers : array(1..10) of Integer;

  protected Controller is
    entry WriteOne(i : Integer);
    entry WriteSeven(i: Integer);
  private
    Last : Integer := 1;
    Count : Integer := -1;
  end Controller;

  protected body Controller is
    entry WriteOne(i: Integer) when Last /= 1 is
    begin
      if Count = 1 then
        Last := 1;
        Count := 0;
      else
        Count := Count + 1;
      end if;
      numbers(i) := 1;
    end WriteOne;

    entry WriteSeven(i: Integer) when Last /= 7 is
    begin
      if Count = -1 or Count = 1 then
        Last := 7;
        Count := 0;
      else
        Count := Count + 1;
      end if;
      numbers(i) := 7;
    end WriteSeven;
  end Controller;

  procedure DoWork is
    task OneWriter;
    task SevenWriter;

    task body OneWriter is
    begin
      Put_Line("Task One Running");
      for n in numbers'Range loop
        Controller.WriteOne(n);
      end loop;
    end OneWriter;

    task body SevenWriter is
    begin
      Put_Line("Task Seven Running");
      for n in numbers'Range loop
        Controller.WriteSeven(n);
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
end Practical4;
