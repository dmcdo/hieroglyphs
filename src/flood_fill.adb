with Ada.Containers.Doubly_Linked_Lists;

package body Flood_Fill is

   procedure Do_Flood_Fill
     (A : in out Array2D; I : Integer; J : Integer; New_Color : Integer)
   is
      type IntPair is array (1 .. 2) of Integer;
      package DLL is new Ada.Containers.Doubly_Linked_Lists
        (Element_Type => IntPair);

      Stack : DLL.List;
      Color : Integer := A (I, J);
      U     : Integer;
      V     : Integer;
   begin
      -- If there is nothing to do, do nothing.
      if Color = New_Color then
         return;
      end if;

      Stack.Append ((I, J));

      while not Stack.Is_Empty loop
         -- pop
         U := Stack.Last_Element (1);
         V := Stack.Last_Element (2);
         Stack.Delete_Last;

         -- if (U, V) is within A's bounds
         if U >= A'First (1) and then U <= A'Last (1) and then
           V >= A'First (2) and then V <= A'Last (2) and then
           A (U, V) = Color
         then
            A (U, V) := New_Color;
            Stack.Append((U - 1, V));
            Stack.Append((U + 1, V));
            Stack.Append((U, V - 1));
            Stack.Append((U, V + 1));

         end if;
      end loop;

   end Do_Flood_Fill;
end Flood_Fill;
