
-- Copyright (C) 2001 Bill Billowitch.

-- Some of the work to develop this test suite was done with Air Force
-- support.  The Air Force and Bill Billowitch assume no
-- responsibilities for this software.

-- This file is part of VESTs (Vhdl tESTs).

-- VESTs is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the
-- Free Software Foundation; either version 2 of the License, or (at
-- your option) any later version. 

-- VESTs is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
-- for more details. 

-- You should have received a copy of the GNU General Public License
-- along with VESTs; if not, write to the Free Software Foundation,
-- Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 

-- ---------------------------------------------------------------------
--
-- $Id: tc475.vhd,v 1.2 2001-10-26 16:29:55 paw Exp $
-- $Revision: 1.2 $
--
-- ---------------------------------------------------------------------

ENTITY model IS
  PORT
    (
      F1:  OUT     integer := 3;
      F2:  INOUT    integer := 3;
      F3:  IN    integer
      );
END model;

architecture model of model is
begin
  process
  begin
    wait for 1 ns;
    assert F3= 3
      report"wrong initialization of F3 through type conversion" severity failure;
    assert F2 = 3
      report"wrong initialization of F2 through type conversion" severity failure;
    wait;
  end process;
end;


ENTITY c03s02b01x01p19n01i00475ent IS
END c03s02b01x01p19n01i00475ent;

ARCHITECTURE c03s02b01x01p19n01i00475arch OF c03s02b01x01p19n01i00475ent IS

  type       boolean_vector is array (natural range <>) of boolean;

  function resolution1(i:in boolean_vector) return boolean is
    variable temp : boolean:= true;
  begin
    return temp;
  end resolution1;

  subtype    boolean_state is resolution1 boolean;
  constant    C66 : boolean_state   := true;

  function complex_scalar(s : boolean_state) return integer is
  begin
    return 3;
  end complex_scalar;
  function scalar_complex(s : integer) return boolean_state is
  begin
    return C66;
  end scalar_complex;
  component model1
    PORT
      (    
        F1:  OUT     integer;
        F2:  INOUT    integer;
        F3:  IN    integer
        );
  end component;
  for T1 : model1 use entity work.model(model);

  signal S1 : boolean_state;
  signal S2 : boolean_state;
  signal S3 : boolean_state:= C66;
BEGIN
  T1: model1
    port map (
      scalar_complex(F1) => S1,
      scalar_complex(F2) => complex_scalar(S2),
      F3 => complex_scalar(S3)
      );
  TESTING: PROCESS
  BEGIN
    wait for 1 ns;
    assert NOT((S1 = C66) and (S2 = C66)) 
      report "***PASSED TEST: c03s02b01x01p19n01i00475" 
      severity NOTE;
    assert ((S1 = C66) and (S2 = C66)) 
      report "***FAILED TEST: c03s02b01x01p19n01i00475 - For an interface object of mode out, buffer, inout, or linkage, if the formal part includes a type conversion function, then the parameter subtype of that function must be a constrained array subtype."
      severity ERROR;
    wait;
  END PROCESS TESTING;

END c03s02b01x01p19n01i00475arch;
