$(document).ready(function(){

	
// function to make numbers more readable - from http://stackoverflow.com/questions/3883342/add-commas-to-a-number-in-jquery
function commaSeparateNumber(val) {
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
}

// LOAD MAP
var map = L.map('map', {
    center: [37.45, -122.16],
    zoom: 10,
    scrollWheelZoom: false
});

// add map tiles
L.tileLayer('http://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    maxZoom: 18
}).addTo(map);

// set polygon color based on jobs/housing ratio
function getColor (property) {
	return property > 2.5    ? '#b30000':
		   property > 2  ? '#e34a33':
		   property > 1.5 ? '#fc8d59':
		   property > 1   ? '#fdcc8a':
		   					 '#5683B0';
}

// prep popup content
function prepPopup (feature, layer) {
	jobs_key = 'jobs_housing_data_job_count_' + active_year;
	housing_key = 'jobs_housing_data_housing_units_' + active_year;
	ratio_key = 'jobs_housing_data_jobs_housing_ratio_' + active_year;

	jobs = commaSeparateNumber(feature.properties[jobs_key]);
	housing = commaSeparateNumber(feature.properties[housing_key]);
	ratio = feature.properties[ratio_key];
	ratio = ratio.toFixed(2);

	layer.bindPopup(
		'<h4>' + feature.properties.NAME + ' (' + active_year + ')</h4><p>Housing units: ' + housing + '</p><p>Jobs: ' + jobs + '</p><p>Jobs per housing unit: ' + ratio + '</p>');
}

// array to hold data layers
map_layers = []

// list of years
years = ['2009', '2010', '2011', '2012', '2013']

// active year constant, since can't pass parameter into onEachFeature function
var active_year;

for (var i = 0; i < years.length; i++) {
	active_year = years[i];

	ratio_key = 'jobs_housing_data_jobs_housing_ratio_' + active_year;

	// prep geojson layer
	active_layer = L.geoJson(jobs_housing_data, {
		style: function(feature) {
			return {
				color: '#fff',
				weight: 2,
				opacity: 1,
				fillColor: getColor(feature.properties[ratio_key]),
				fillOpacity: 1,
			};
		},
		onEachFeature: prepPopup
	});

	// add layer to array
	map_layers.push(active_layer);

	// add layer to map
	map_layers[i].addTo(map);	
}

// store array of map toggle links
$map_toggles = $('.map-toggle-link');

// counter to track active layer
active_layer_index = 0;

function changeLayer() {

	// update map
	map_layers[active_layer_index].bringToFront();

	// update map toggles
	$map_toggles.removeClass('current');
	$map_toggles.eq(active_layer_index).addClass('current');
}

function advanceLayer() {
	last_layer_index = map_layers.length - 1;

	// select next map layer
	if (active_layer_index < last_layer_index) {
		active_layer_index++;
	} else {
		active_layer_index = 0;
	};

	// update map
	changeLayer();
}

// initialize map
changeLayer();

// start auto cycling
auto_cycle_map = setInterval(advanceLayer, 2000);


// toggle topmost layer
$map_toggles.click(function(event) {
	event.preventDefault();

	// stop auto cycling
	clearInterval(auto_cycle_map);

	// change map layer
	selected_layer_text = $(this).data('map-layer');
	active_layer_index = parseInt(selected_layer_text) - 2009;
	changeLayer();
});

// play/pause controls
$('.animation-control a').click(function(event) {
	event.preventDefault();
	$this = $(this);
	if ($this.hasClass('paused')) {

		// start playing again
		auto_cycle_map = setInterval(advanceLayer, 2000);

		// change icon back to pause
		$this.removeClass('paused');

		// change text
		$this.text('Pause Animation');

		
	} else {

		// stop playing
		clearInterval(auto_cycle_map);

		// change icon to play
		$this.addClass('paused');

		// change text
		$this.text('Play Animation');

	}
});


});


