function benchChart(filename, selector) {

d3.csv(filename, function(error, csvdata){
		// console.log(csvdata)

    csvdata = csvdata.sort(function(a, b) {
        return d3.ascending(+a.real, +b.real);
    });


		// create an empty object that nv is expecting
    var test_data = [
    	{
    		key: "real",
    		values: []
    	},
      {
    		key: "user",
    		values: []
    	}
    ];

    var i = 0;
    // populate the empty object with your data
    csvdata.forEach(function (d) {

        d.real = +d.real
        d.user = +d.user
        d.system = +d.system
  	    test_data[0].values.push({'x': d.name, 'y': d.real})
        test_data[1].values.push({'x': d.name, 'y': d.user})
        i += 1;
    })
    console.log('td', test_data);

    var chart;
    nv.addGraph(function() {
        chart = nv.models.multiBarChart()
            .barColor(d3.scale.category20().range())
            .duration(300)
            .margin({bottom: 100, left: 70})
            .rotateLabels(45)
            .groupSpacing(0.1)
        ;
        chart.reduceXTicks(false).staggerLabels(true);
        chart.xAxis
            .axisLabel("ID")
            .axisLabelDistance(35)
            .showMaxMin(false)
        ;
        chart.yAxis
            .axisLabel("Seconds")
            .axisLabelDistance(-5)
            .tickFormat(d3.format(',.01f'))
        ;
        chart.dispatch.on('renderEnd', function(){
            nv.log('Render Complete');
        });


       d3.select(selector)
            .datum(test_data)
            .call(chart);

				nv.utils.windowResize(chart.update);
				 chart.dispatch.on('stateChange', function(e) {
						 nv.log('New State:', JSON.stringify(e));
				 });
				 chart.state.dispatch.on('change', function(state){
						 nv.log('state', JSON.stringify(state));
				 });
    });
    return chart;
});
};
