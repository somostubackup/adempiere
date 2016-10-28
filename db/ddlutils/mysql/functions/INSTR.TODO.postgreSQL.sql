 /**********************************************************************
 * This file is part of ADempiere Business Suite                       *
 * http://www.adempiere.org                                            *
 *                                                                     *
 * Copyright (C) Trifon Trifonov.                                      *
 * Copyright (C) Contributors                                          *
 *                                                                     *
 * This program is free software; you can redistribute it and/or       *
 * modify it under the terms of the GNU General Public License         *
 * as published by the Free Software Foundation; either version 2      *
 * of the License, or (at your option) any later version.              *
 *                                                                     *
 * This program is distributed in the hope that it will be useful,     *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of      *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the        *
 * GNU General Public License for more details.                        *
 *                                                                     *
 * You should have received a copy of the GNU General Public License   *
 * along with this program; if not, write to the Free Software         *
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,          *
 * MA 02110-1301, USA.                                                 *
 *                                                                     *
 * Contributors:                                                       *
 * - Trifon Trifonov (trifonnt@users.sourceforge.net)                  *
 *                                                                     *
 ***********************************************************************
 * 
 */
-- Taken from http://developer.postgresql.org/pgdocs/postgres/plpgsql-porting.html#PLPGSQL-PORTING-APPENDIX

--
-- instr functions that mimic Oracle's counterpart
-- Syntax: instr(string1, string2, [n], [m]) where [] denotes optional parameters.
--
-- Searches string1 beginning at the nth character for the mth occurrence
-- of string2.  If n is negative, search backwards.  If m is not passed,
-- assume 1 (search starts at first character).
--
/**********************************************************************
* Se modifica y se crean 2 funciones con un número que identifica la  *
* cantidad de parámetros, luego se modifica en la clase respectiva    *
* para que haga la traducción de la función en base a los parámetros  *
***********************************************************************
 * 
 */

DELIMITER $$

CREATE FUNCTION instr3(string varchar(255), string_to_search varchar(255), beg_index integer)
RETURNS integer
BEGIN
DECLARE pos integer DEFAULT 0;
DECLARE temp_str varchar(255);
DECLARE beg integer;
DECLARE length integer;
DECLARE ss_length integer;

    IF (beg_index > 0) THEN
        SET temp_str = substring(string,beg_index);
        SET pos = instr( temp_str, string_to_search);

        IF (pos = 0) THEN
            RETURN 0;
        ELSE
            RETURN pos + beg_index - 1;
        END IF;
    ELSE
         set ss_length = length(string_to_search);
        set length = length(string);
        set beg = length + beg_index - ss_length + 2;

        index_loop: LOOP
			IF beg <=0 THEN 
				LEAVE index_loop;
			END IF;
            SET temp_str = substring(string, beg,ss_length);
            set pos = instr(string_to_search,temp_str);

            IF pos > 0 THEN
                RETURN beg;
            END IF;

            SET beg = beg - 1;
        END LOOP;

        RETURN 0;
    END IF;
END;
$$ 


CREATE FUNCTION instr4(string varchar(255), string_to_search varchar(255),
                      beg_index integer, occur_index integer)
RETURNS integer 
BEGIN
DECLARE pos integer DEFAULT 0;
DECLARE occur_number integer DEFAULT 0;
DECLARE temp_str varchar(255);
DECLARE beg integer;
DECLARE i integer;
DECLARE length integer;
DECLARE ss_length integer;
    IF beg_index > 0 THEN
        set beg = beg_index;
        set temp_str = substring(string,beg_index);
		index_loop: LOOP
			IF i > occur_index THEN
				LEAVE index_loop;
			END IF;
			 SET pos = instr(string_to_search, temp_str);
				IF i = 1 THEN
					SET beg = beg + pos - 1;
				ELSE
					SET beg = beg + pos;
				END IF;

				SET temp_str = substring(string FROM beg + 1);
        END LOOP;

        IF pos = 0 THEN
            RETURN 0;
        ELSE
            RETURN beg;
        END IF;
    ELSE
        SET ss_length = length(string_to_search);
        SET length = length(string);
        SET beg = length + beg_index - ss_length + 2;
		index_loop: LOOP
			IF beg <= 0 THEN
				LEAVE index_loop;
			END IF;
			SET temp_str = substring(string,beg,ss_length);
            SET pos = INSTR(string_to_search,temp_str);
            IF pos > 0 THEN
                SET occur_number = occur_number + 1;
                IF occur_number = occur_index THEN
                    RETURN beg;
                END IF;
            END IF;

            SET beg = beg - 1;
        END LOOP;

        RETURN 0;
    END IF;
END;
$$
