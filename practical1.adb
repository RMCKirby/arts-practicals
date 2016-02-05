with Ada.Text_IO; use Ada.Text_IO;
procedure Practical1 is
  task Hello;
  task body Hello is
  begin
    Put_Line("Hello World");
  end Hello;

begin
  null;
end Practical1;
