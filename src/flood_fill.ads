package Flood_Fill is

   type Array2D is array (Integer range <>, Integer range <>) of Integer;

   -- Performs flood fill on A at A (I, J) of New_Color
   procedure Do_Flood_Fill
     (A : in out Array2D; I : Integer; J : Integer; New_Color : Integer);

end Flood_Fill;
