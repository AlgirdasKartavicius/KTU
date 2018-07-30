<?php

	include 'libraries/Siunta.class.php';
	$siuntaObj = new Siunta();
	
	$formErrors = null;
	$fields = array();

	// nustatome privalomus laukus
	$required = array('kodas', 'pristatymoData', 'gavejoAdresas', 'pakuotesDydis', 'fk_AptarnaujantisAsistentastabelioNr', 'fk_SiuntuPervezimoTarnybaid', 'fk_UzsakymasuzsakymoNumeris', 'fk_Pirkejaskodas');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'kodas' => 9
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		// sukuriame laukų validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'kodas' => 'alfanum',
			'svoris' => 'float',
			'pristatymoData' => 'date',
			'gavejoAdresas' => 'alfanum',
			'draudimoKaina' => 'price',
			'pakuotesDydis' => 'positivenumber',
			'mokejimoBudas' => 'positivenumber',
			'fk_Pirkejaskodas' => 'alfanum',
			'fk_AptarnaujantisAsistentastabelioNr' => 'alfanum',
			'fk_SiuntuPervezimoTarnybaid' => 'positivenumber',
			'fk_UzsakymasuzsakymoNumeris' => 'alfanum');
				
		
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			
			if(isset($data['editing'])) {
				// atnaujiname duomenis
				$siuntaObj->updateSiunta($data);
			} else {
				
				$tmp = $siuntaObj->getSiunta($data['kodas']);
				$tmpUzs = $siuntaObj->getUzsKiekis($data['fk_UzsakymasuzsakymoNumeris']);
				
				if(isset($tmp['kodas'])){
					if ($tmpUzs > 0){
						// sudarome klaidų pranešimą
						$formErrors = "Siunta su įvestu kodu jau egzistuoja ir pasirinktam užsakymui jau yra priskirta kita siunta.";
					}
					else{
						// sudarome klaidų pranešimą
						$formErrors = "Siunta su įvestu kodu jau egzistuoja.";
					}
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else if($tmpUzs > 0){
					// sudarome klaidų pranešimą
					$formErrors = "Pasirinktam užsakymui jau yra priskirta kita siunta.";
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else{
				
				// įrašome naują siuntą
					$siuntaObj->insertSiunta($data);
				}
				
			}
			if($formErrors == null) {
				// nukreipiame vartotoją į siuntų puslapį
				header("Location: index.php?module={$module}");
				die();
			}
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame prekę
			$fields = $siuntaObj->getSiunta($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Siuntos</a></li>
	<li><?php if(!empty($id)) echo "Siuntos redagavimas"; else echo "Nauja siunta"; ?></li>
</ul>
<div class="float-clear"></div>
<div id="formContainer">
	<?php if($formErrors != null) { ?>
		<div class="errorBox">
			Neįvesti arba neteisingai įvesti šie laukai:
			<?php 
				echo $formErrors;
			?>
		</div>
	<?php } ?>
	<form action="" method="post">
		<fieldset>
			<legend>Siuntos informacija</legend>
			<p>
				<label class="field" for="kodas">Siuntos kodas<?php echo in_array('kodas', $required) ? '<span> *</span>' : ''; ?></label>
					<?php if(!isset($fields['editing'])) { ?>
						<input type="text" id="kodas" name="kodas" class="textbox-150" value="<?php echo isset($fields['kodas']) ? $fields['kodas'] : ''; ?>" />
						<?php if(key_exists('kodas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['kodas']} simb.)</span>"; ?>
					<?php } else { ?>
						<span class="input-value"><?php echo $fields['kodas']; ?></span>
						<input type="hidden" name="editing" value="1" />
						<input type="hidden" name="kodas" value="<?php echo $fields['kodas']; ?>" />
					<?php } ?>
			</p>
			<p>
				<label class="field" for="svoris">Svoris<?php echo in_array('svoris', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="svoris" name="svoris" class="textbox-70" value="<?php echo isset($fields['svoris']) ? $fields['svoris'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="pristatymoData">Pristatymo data<?php echo in_array('pristatymoData', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="pristatymoData" name="pristatymoData" class="date textbox-70" value="<?php echo isset($fields['pristatymoData']) ? $fields['pristatymoData'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="gavejoAdresas">Gavėjo adresas<?php echo in_array('gavejoAdresas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="gavejoAdresas" name="gavejoAdresas" class="textbox-150" value="<?php echo isset($fields['gavejoAdresas']) ? $fields['gavejoAdresas'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="draudimoKaina">Draudimo kaina<?php echo in_array('draudimoKaina', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="draudimoKaina" name="draudimoKaina" class="textbox-70" value="<?php echo isset($fields['draudimoKaina']) ? $fields['draudimoKaina'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="pakuotesDydis">Pakuotės dydis<?php echo in_array('pakuotesDydis', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="pakuotesDydis" name="pakuotesDydis">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$pakuotesDydisObj = $siuntaObj->getPakuotesDydisList();
						foreach($pakuotesDydisObj as $key => $val) {
							$selected = "";
							if(isset($fields['pakuotesDydis']) && $fields['pakuotesDydis'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_AptarnaujantisAsistentastabelioNr">Aptarnaujančio asistento tabelio nr.<?php echo in_array('fk_AptarnaujantisAsistentastabelioNr', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_AptarnaujantisAsistentastabelioNr" name="fk_AptarnaujantisAsistentastabelioNr">
					<option value="-1">Pasirinkite asistentą</option>
					<?php
						// išrenkame visus asistentus
						$asistentai = $siuntaObj->getAsistentasList();
						foreach($asistentai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_AptarnaujantisAsistentastabelioNr']) && $fields['fk_AptarnaujantisAsistentastabelioNr'] == $val['tabelioNr']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['tabelioNr']}'>{$val['tabelioNr']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_SiuntuPervezimoTarnybaid">Siuntų pervežimo tarnyba<?php echo in_array('fk_SiuntuPervezimoTarnybaid', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_SiuntuPervezimoTarnybaid" name="fk_SiuntuPervezimoTarnybaid">
					<option value="-1">Pasirinkite tarnybą</option>
					<?php
						// išrenkame visus asistentus
						$tarnybos = $siuntaObj->getSiuntuPervezimoTarnybaList();
						foreach($tarnybos as $key => $val) {
							$selected = "";
							if(isset($fields['fk_SiuntuPervezimoTarnybaid']) && $fields['fk_SiuntuPervezimoTarnybaid'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['pavadinimas']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_UzsakymasuzsakymoNumeris">Užsakymo numeris<?php echo in_array('fk_UzsakymasuzsakymoNumeris', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_UzsakymasuzsakymoNumeris" name="fk_UzsakymasuzsakymoNumeris">
					<option value="-1">Pasirinkite užsakymą</option>
					<?php
						// išrenkame visus užsakymus
						$uzsakymai = $siuntaObj->getUzsakymasList();
						foreach($uzsakymai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_UzsakymasuzsakymoNumeris']) && $fields['fk_UzsakymasuzsakymoNumeris'] == $val['uzsakymoNumeris']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['uzsakymoNumeris']}'>{$val['uzsakymoNumeris']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_Pirkejaskodas">Pirkėjo kodas<?php echo in_array('fk_Pirkejaskodas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_Pirkejaskodas" name="fk_Pirkejaskodas">
					<option value="-1">Pasirinkite pirkėją</option>
					<?php
						// išrenkame visus pirkėjus
						$pirkejai = $siuntaObj->getPirkejasList();
						foreach($pirkejai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_Pirkejaskodas']) && $fields['fk_Pirkejaskodas'] == $val['kodas']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['kodas']}'>{$val['kodas']}</option>";
						}
					?>
				</select>
			</p>
		</fieldset>
		<p class="required-note">* pažymėtus laukus užpildyti privaloma</p>
		<p>
			<input type="submit" class="submit" name="submit" value="Išsaugoti">
		</p>
		<?php if(isset($fields['id'])) { ?>
			<input type="hidden" name="id" value="<?php echo $fields['id']; ?>" />
		<?php } ?>
	</form>
</div>