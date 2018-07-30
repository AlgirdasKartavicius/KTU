<?php

/**
 * Siuntų pervežimo tarnybų redagavimo klasė
 *
 * @author MK
 */

class SiuntuPervezimoTarnyba{
	
	public function __construct() {
		
	}
	
	/**
	 * Siuntų pervežimo tarnybos išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSiuntuPervezimoTarnyba($id) {
		$query = "  SELECT *
					FROM `SiuntuPervezimoTarnyba`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Siuntų pervežimo tarnybų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSiuntuPervezimoTarnybaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `SiuntuPervezimoTarnyba`.`id`,
						   `SiuntuPervezimoTarnyba`.`pavadinimas`,
						   `SiuntuPervezimoTarnyba`.`transportoPriemoniuKiekis`,
						   `TransportoPriemones`.`name` AS `transportoPriemones`
					FROM `SiuntuPervezimoTarnyba`
						LEFT JOIN `TransportoPriemones`
							ON `SiuntuPervezimoTarnyba`.`transportoPriemone`=`TransportoPriemones`.`id` LIMIT {$limit} OFFSET {$offset}";
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Siuntų pervežimo tarnybų kiekio radimas
	 * @return type
	 */
	public function getSiuntuPervezimoTarnybaListCount() {
		$query = "  SELECT COUNT(`SiuntuPervezimoTarnyba`.`id`) as `kiekis`
					FROM `SiuntuPervezimoTarnyba`
						LEFT JOIN `TransportoPriemones`
							ON `SiuntuPervezimoTarnyba`.`transportoPriemone`=`TransportoPriemones`.`id`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Siuntų pervežimo tarnybų išrinkimas pagal transporto priemonę
	 * @param type $brandId
	 * @return type
	 */
	public function getSiuntuPervezimoTarnybaByTransportoPriemones($sportId) {
		$query = "  SELECT *
					FROM `SiuntuPervezimoTarnyba`
					WHERE `transportoPriemone`='{$sportId}'";
		$data = mysql::select($query);
		
		return $data;
	}
	
	/**
	 * Siuntų pervežimo tarnybos atnaujinimas
	 * @param type $data
	 */
	public function updateSiuntuPervezimoTarnyba($data) {
		$query = "  UPDATE `SiuntuPervezimoTarnyba`
					SET    `pavadinimas`='{$data['pavadinimas']}',
						   `transportoPriemonesTalpa`='{$data['transportoPriemonesTalpa']}',
						   `pristatymoGreitisValandomis`='{$data['pristatymoGreitisValandomis']}',
						   `transportoPriemoniuKiekis`='{$data['transportoPriemoniuKiekis']}',
						   `laukimoTarifasUzValanda`='{$data['laukimoTarifasUzValanda']}',
						   `transportoPriemone`='{$data['transportoPriemone']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Siuntų pervežimo tarnybos įrašymas
	 * @param type $data
	 */
	public function insertSiuntuPervezimoTarnyba($data) {
		$query = "  INSERT INTO `SiuntuPervezimoTarnyba`
								(
									`id`,
									`pavadinimas`,
									`transportoPriemonesTalpa`,
									`pristatymoGreitisValandomis`,
									`transportoPriemoniuKiekis`,
									`laukimoTarifasUzValanda`,
									`transportoPriemone`
								)
								VALUES
								(
									'{$data['id']}',
									'{$data['pavadinimas']}',
									'{$data['transportoPriemonesTalpa']}',
									'{$data['pristatymoGreitisValandomis']}',
									'{$data['transportoPriemoniuKiekis']}',
									'{$data['laukimoTarifasUzValanda']}',
									'{$data['transportoPriemone']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Siuntų pervežimo tarnybos šalinimas
	 * @param type $id
	 */
	public function deleteSiuntuPervezimoTarnyba($id) {
		$query = "  DELETE FROM `SiuntuPervezimoTarnyba`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Nurodytos siuntų pervežimo tarnybos siuntų kiekio radimas
	 * @param type $id
	 * @return type
	 */
	public function getSiuntaCountOfSiuntuPervezimoTarnyba($id) {
		$query = "  SELECT COUNT(`Siunta`.`fk_SiuntuPervezimoTarnybaid`) AS `kiekis`
					FROM `SiuntuPervezimoTarnyba`
						INNER JOIN `Siunta`
							ON `SiuntuPervezimoTarnyba`.`id`=`Siunta`.`fk_SiuntuPervezimoTarnybaid`
					WHERE `SiuntuPervezimoTarnyba`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausios siuntų pervežimo tarnybos id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfSiuntuPervezimoTarnyba() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `SiuntuPervezimoTarnyba`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}