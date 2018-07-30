<?php

/**
 * Transporto priemonių redagavimo klasė
 *
 * @author MK
 */

class TransportoPriemones {

	public function __construct() {
		
	}
	
	/**
	 * Transporto priemonės išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getTransportoPriemones($id) {
		$query = "  SELECT *
					FROM `TransportoPriemones`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Transporto priemonių sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getTransportoPriemonesList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `TransportoPriemones`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Transporto priemonių kiekio radimas
	 * @return type
	 */
	public function getTransportoPriemonesListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `TransportoPriemones`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Transporto priemonės įrašymas
	 * @param type $data
	 */
	public function insertTransportoPriemones($data) {
		$query = "  INSERT INTO `TransportoPriemones`
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
	 * Transporto priemonės atnaujinimas
	 * @param type $data
	 */
	public function updateTransportoPriemones($data) {
		$query = "  UPDATE `TransportoPriemones`
					SET    `name`='{$data['name']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Transporto priemonės šalinimas
	 * @param type $id
	 */
	public function deleteTransportoPriemones($id) {
		$query = "  DELETE FROM `TransportoPriemones`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Transporto priemonių kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getTarnybaCountOfTransportoPriemones($id) {
		$query = "  SELECT COUNT(`TransportoPriemones`.`id`) AS `kiekis`
					FROM `TransportoPriemones`
						INNER JOIN `SiuntuPervezimoTarnyba`
							ON `TransportoPriemones`.`id`=`SiuntuPervezimoTarnyba`.`transportoPriemone`
					WHERE `TransportoPriemones`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios transporto priemonės id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfTransportoPriemones() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `TransportoPriemones`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
}