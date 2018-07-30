<?php

/**
 * Prėkės būsenos redagavimo klasė
 *
 * @author MK
 */

class Busena {

	public function __construct() {
		
	}
	
	/**
	 * Būsenos išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getBusena($id) {
		$query = "  SELECT *
					FROM `Busena`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Būsenų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getBusenaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `Busena`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Būsenų kiekio radimas
	 * @return type
	 */
	public function getBusenaListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `Busena`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Būsenos įrašymas
	 * @param type $data
	 */
	public function insertBusena($data) {
		$query = "  INSERT INTO `Busena`
								(
									`id`,
									`name`
								)
								VALUES
								(
									'{$data['id']}',
									'{$data['name']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Būsenos atnaujinimas
	 * @param type $data
	 */
	public function updateBusena($data) {
		$query = "  UPDATE `Busena`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Būsenos šalinimas
	 * @param type $id
	 */
	public function deleteBusena($id) {
		$query = "  DELETE FROM `Busena`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Būsenos kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getModelCountOfBusena($id) {
		$query = "  SELECT COUNT(`Busena`.`id`) AS `kiekis`
					FROM `Busena`
						INNER JOIN `Preke`
							ON `Busena`.`id`=`Preke`.`busena`
					WHERE `Busena`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios būsenos id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfBusena() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `Busena`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}