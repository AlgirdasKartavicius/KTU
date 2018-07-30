<?php

/**
 * Pirkėjų redagavimo klasė
 *
 * @author MK
 */

class Pirkejas {
	
	public function __construct() {
		
	}
	
	/**
	 * Pirkėjo išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getPirkejas($id) {
		$query = "  SELECT *
					FROM `Pirkejas`
					WHERE `kodas`='{$id}'";
		$data = mysql::select($query);
		if (empty($data))
			return null;
		return $data[0];
	}
	
	/**
	 * Pirkėjų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getPirkejasList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `Pirkejas`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}
	
	/**
	 * Pirkėjų kiekio radimas
	 * @return type
	 */
	public function getPirkejasListCount() {
		$query = "  SELECT COUNT(`kodas`) as `kiekis`
					FROM `Pirkejas`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Pirkėjų šalinimas
	 * @param type $id
	 */
	public function deletePirkejas($id) {
		$query = "  DELETE FROM `Pirkejas`
					WHERE `kodas`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Pirkėjų atnaujinimas
	 * @param type $data
	 */
	public function updatePirkejas($data) {
		$query = "  UPDATE `Pirkejas`
					SET    `prisijungimoVardas`='{$data['prisijungimoVardas']}',
						   `slaptazodis`='{$data['slaptazodis']}',
						   `vardas`='{$data['vardas']}',
						   `pavarde`='{$data['pavarde']}',
						   `telefonas`='{$data['telefonas']}',
						   `el_pastas`='{$data['el_pastas']}',
						   `adresas`='{$data['adresas']}'
					WHERE `kodas`='{$data['kodas']}'";
		mysql::query($query);
	}
	
	/**
	 * Pirkėjo įrašymas
	 * @param type $data
	 */
	public function insertPirkejas($data) {
		$query = "  INSERT INTO `Pirkejas`
								(
									`kodas`,
									`prisijungimoVardas`,
									`slaptazodis`,
									`vardas`,
									`pavarde`,
									`telefonas`,
									`el_pastas`,
									`adresas`
								) 
								VALUES
								(
									'{$data['kodas']}',
									'{$data['prisijungimoVardas']}',
									'{$data['slaptazodis']}',
									'{$data['vardas']}',
									'{$data['pavarde']}',
									'{$data['telefonas']}',
									'{$data['el_pastas']}',
									'{$data['adresas']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Užsakymų, į kuriuos įtrauktas pirkėjas, kiekio radimas
	 * @param type $id
	 * @return type
	 */
	public function getUzsakymasCountOfPirkejas($id) {
		$query = "  SELECT COUNT(`Uzsakymas`.`uzsakymoNumeris`) AS `kiekis`
					FROM `Pirkejas`
						INNER JOIN `Uzsakymas`
							ON `Pirkejas`.`kodas`=`Uzsakymas`.`fk_Pirkejaskodas`
					WHERE `Pirkejas`.`kodas`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	public function getSiuntosCount($id) {
		$query = "  SELECT COUNT(`Saskaita`.`nr`) AS `kiekis`
					FROM `Pirkejas`
						INNER JOIN `Saskaita`
							ON `Pirkejas`.`kodas`=`Saskaita`.`fk_Pirkejaskodas`
					WHERE `Pirkejas`.`kodas`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	public function getSaskaitosCount($id) {
		$query = "  SELECT COUNT(`Siunta`.`kodas`) AS `kiekis`
					FROM `Pirkejas`
						INNER JOIN `Siunta`
							ON `Pirkejas`.`kodas`=`Siunta`.`fk_Pirkejaskodas`
					WHERE `Pirkejas`.`kodas`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	public function getPristatoSiuntaCount($id) {
		$query = "  SELECT COUNT(`PristatoSiunta`.`id`) AS `kiekis`
					FROM `Pirkejas`
						INNER JOIN `PristatoSiunta`
							ON `Pirkejas`.`kodas`=`PristatoSiunta`.`fk_Pirkejaskodas`
					WHERE `Pirkejas`.`kodas`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
}