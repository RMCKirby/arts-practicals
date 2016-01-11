with Ada.Text_IO; use Ada.Text_IO;
procedure Practical5 is

  Releaser : constant Integer := 3;

  protected Controller is
    --entry
  end Controller;

  task type Client(Id : Integer);

  task body Client is
  begin
    null;
  end Client;

begin
  null;
end Practical5;
