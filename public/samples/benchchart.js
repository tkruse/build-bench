
function benchChart(filename, selector, columns) {
d3.csv(filename, function(error, csvdata){

    var chart_names = [];
    csvdata.forEach(function(d) {
        chart_names.push(d.name);
    });


    csvdata = csvdata.sort(function(a, b) {
        return d3.ascending(+a[columns[0]], +b[columns[0]]);
    });


		// create an empty object that nv is expecting
    var test_data = [
    ];
    columns.forEach(function(col) {
			  test_data.push({
			      key: col,
			      values: []
			  });
		});

    // populate the empty object with your data
    csvdata.forEach(function(d) {
        i = 0;
        columns.forEach(function(col) {
            d[col] = +d[col];
            test_data[i].values.push({'x': d.name, 'y': d[col]});
            i += 1;
        });
    });

    var chart;
    nv.addGraph(function() {
        chart = nv.models.multiBarChart()
            .barColor(function(d) {
                return d3.scale.category10().range()[chart_names.indexOf(d.x)]
            })
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
            .axisLabel("value")
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

function benchTable(filename, selector, columns) {
d3.csv(filename, function(error, csvdata) {
    csvdata = csvdata.sort(function(a, b) {
        return d3.ascending(+a[columns[0]], +b[columns[0]]);
    });

    table = d3.select(selector)
        .append('table');
    thead = table.append('thead')
	  tbody = table.append('tbody')

	  thead.append('tr')
	  .selectAll('th')
	    .data(columns)
	    .enter()
	  .append('th')
	    .text(function (d) { return d })

	var rows = tbody.selectAll('tr')
	    .data(csvdata)
	    .enter()
	  .append('tr')

	var cells = rows.selectAll('td')
	    .data(function(row) {
	    	  return columns.map(function (column) {
	    		    return { column: column, value: row[column] }
	        })
      })
      .enter()
      .append('td')
      .html(function (d) { return d.value} )
    return table;
});
};
