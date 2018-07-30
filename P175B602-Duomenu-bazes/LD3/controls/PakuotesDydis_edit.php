<?php

	include 'libraries/PakuotesDydis.class.php';
	$pakuotesDydisObj = new PakuotesDydis();
	
	$formErrors = null;
	$fields = array();
	
	// nustatome privalomus laukus
	$required = array('name');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'name' => 20
	);
	
	// paspaustas išsaugojimo mygtukas
	if(!empty($_POST['submit'])) {
		// nustatome laukų validatorių tipus
		$validations = array (
			'name' => 'alfanum');
		
		// sukuriame validatoriaus objektą
		include 'utils/validator.class.php';
		$validator = new validator($validations, $required, $maxLengths);

		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			if(isset($data['id'])) {
				// atnaujiname duomenis
				$pakuotesDydisObj->updatePakuotesDydis($data);
			} else {
				// randame didžiausio pakuotės dydžio id duomenų bazėje
				$latestId = $pakuotesDydisObj->getMaxIdOfPakuotesDydis();
				
				// įrašome naują įrašą
				$data['id'] = $latestId + 1;
				$pakuotesDydisObj->insertPakuotesDydis($data);
			}
			
			// nukreipiame į pakuotės dydžių puslapį
			header("Location: index.php?module={$module}");
			die();
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// gauname įvestus laukus
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			$fields = $pakuotesDydisObj->getPakuotesDydis($id);
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Pakuotės dydžiai</a></li>
	<li><?php if(!empty($id)) echo "Pakuotės dydžio redagavimas"; else echo "Naujas pakuotės dydis"; ?></li>
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
			<legend>Pakuotės dydžio informacija</legend>
			<p>
				<label class="field" for="name">Pavadinimas<?php echo in_array('name', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="name" name="name" class="textbox-150" value="<?php echo isset($fields['name']) ? $fields['name'] : ''; ?>">
				<?php if(key_exists('name', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['name']} simb.)</span>"; ?>
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