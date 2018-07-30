<?php

/**
 * Aptarnaujančių asistentų redagavimo klasė
 *
 * @author MK
 */

class AptarnaujantisAsistentas {
	
	public function __construct() {
		
	}
	
	/**
	 * Asistento išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getAptarnaujantisAsistentas($id) {
		$query = "  SELECT *
					FROM `AptarnaujantisAsistentas`
					WHERE `tabelioNr`='{$id}'";
		$data = mysql::select($query);
		if (empty($data))
			return null;
		return $data[0];
	}
	
	/**
	 * Asistentų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getAptarnaujantisAsistentasList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `AptarnaujantisAsistentas`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}
	
	/**
	 * Asistentų kiekio radimas
	 * @return type
	 */
	public function getAptarnaujantisAsistentasListCount() {
		$query = "  SELECT COUNT(`tabelioNr`) as `kiekis`
					FROM `AptarnaujantisAsistentas`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Asistentų šalinimas
	 * @param type $id
	 */
	public function deleteAptarnaujantisAsistentas($id) {
		$query = "  DELETE FROM `AptarnaujantisAsistentas`
					WHERE `tabelioNr`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Asistentų atnaujinimas
	 * @param type $data
	 */
	public function updateAptarnaujantisAsistentas($data) {
		$query = "  UPDATE `AptarnaujantisAsistentas`
					SET    `vardas`='{$data['vardas']}',
						   `pavarde`='{$data['pavarde']}',
						   `telefonas`='{$data['telefonas']}',
						   `el_pastas`='{$data['el_pastas']}'
					WHERE `tabelioNr`='{$data['tabelioNr']}'";
		mysql::query($query);
	}
	
	/**
	 * Asistento įrašymas
	 * @param type $data
	 */
	public function insertAptarnaujantisAsistentas($data) {
		$query = "  INSERT INTO `AptarnaujantisAsistentas`
								(
									`tabelioNr`,
									`vardas`,
									`pavarde`,
									`telefonas`,
									`el_pastas`
								) 
								VALUES
								(
									'{$data['tabelioNr']}',
									'{$data['vardas']}',
									'{$data['pavarde']}',
									'{$data['telefonas']}',
									'{$data['el_pastas']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Sąskaitų, į kurias įtrauktas asistentas, kiekio radimas
	 * @param type $id
	 * @return type
	 */
	public function getSaskaitaCountOfAptarnaujantisAsistentas($id) {
		$query = "  SELECT COUNT(`Saskaita`.`nr`) AS `kiekis`
					FROM `AptarnaujantisAsistentas`
						INNER JOIN `Saskaita`
							ON `AptarnaujantisAsistentas`.`tabelioNr`=`Saskaita`.`fk_AptarnaujantisAsistentastabelioNr`
					WHERE `AptarnaujantisAsistentas`.`tabelioNr`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	public function getUzsakymaiCount($id) {
		$query = "  SELECT COUNT(`Uzsakymas`.`uzsakymoNumeris`) AS `kiekis`
					FROM `AptarnaujantisAsistentas`
						INNER JOIN `Uzsakymas`
							ON `AptarnaujantisAsistentas`.`tabelioNr`=`Uzsakymas`.`fk_AptarnaujantisAsistentastabelioNr`
					WHERE `AptarnaujantisAsistentas`.`tabelioNr`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	public function getSiuntosCount($id) {
		$query = "  SELECT COUNT(`Siunta`.`kodas`) AS `kiekis`
					FROM `AptarnaujantisAsistentas`
						INNER JOIN `Siunta`
							ON `AptarnaujantisAsistentas`.`tabelioNr`=`Siunta`.`fk_AptarnaujantisAsistentastabelioNr`
					WHERE `AptarnaujantisAsistentas`.`tabelioNr`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
}