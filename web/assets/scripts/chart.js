$(document).ready(function(){

// function to make numbers more readable - from http://stackoverflow.com/questions/3883342/add-commas-to-a-number-in-jquery
function commaSeparateNumber(val){
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
}

// BUILD LINE CHART
var chart_data = {
  labels: ['2009', '2010', '2011', '2012', '2013'],
  series: [{
  	name: 'Jobs',
  	data: [1054938, 1061114, 1083003, 1112953, 1174518]
  },{
  	name: 'Housing Units',
  	data: [887622, 902961, 904712, 907007, 914808]
  }]
};

var chart_options = {
	fullWidth: true,
	chartPadding: {
	    top: 15,
	    right: 5,
	    bottom: 0,
	    left: 0
	},
	axisX: {
		showGrid: false,
		labelOffset: {
	      x: -30,
	      y: 10
	    },
	},
	axisY: {
		showGrid: false,
		offset: 90,
		labelOffset: {
	      x: -15,
	      y: 0
	    },
	    scaleMinSpace: 40,
	    low: 850000,
	    labelInterpolationFnc: function (value) {
	    	return commaSeparateNumber(value);
	    }
	}
}

new Chartist.Line('.ct-chart', chart_data, chart_options);

});




