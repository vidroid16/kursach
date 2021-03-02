<template>
    <v-container :isRedraw="render">
        <v-btn @click="render" style=""></v-btn>
        <canvas id="myChart" width="500px" height="500px"></canvas>
    </v-container>
</template>
<script>
import {EventBus} from '../bus.js';
import {Chart} from 'chart.js';
export default {
  name: 'Grafik',
  data: function(){
      return{
      }
  },
  created(){
     EventBus.$on('isRedraw',()=>{
       this.render();
     });
  },
  mounted(){
    
  },
  methods:{
      render:function(){
        var ctx = document.getElementById('myChart');
        var data = {
	labels: [-25, -5,-2.5,0,2.5,5, 25],
    datasets: [{
        label: "f(x)",
        function: function(x) { return x },
        borderColor: "rgba(75, 192, 192, 1)",
        data: [],
        fill: false
    },
    {
        label: "L(x)",
        function: function(x) { return x*x },
        borderColor: "rgba(153, 102, 245, 1)",
        data: [],
        fill: false
    },
    {
        label: "ps",
        function:function(x){return x},
        borderColor: "rgba(52, 112, 22, 1)",
        data: [
            {x:1,y:2}
        ],
        fill: false
    }
    ]
};

Chart.pluginService.register({
    beforeInit: function(chart) {
        var data = chart.config.data;
        for (var i = 0; i < data.datasets.length; i++) {
            for (var j = 0; j < data.labels.length; j++) {
                var fct = data.datasets[i].function,
                x = data.labels[j],
                y = fct(x);
                data.datasets[i].data.push(y);
            }
        }
    }
});

var myBarChart = new Chart(ctx, {
    type: 'line',
    data: data,
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero:true
                }
            }]
        },
        elements: {
            point:{
                  radius: 5
            }
        },
        responsive: false
    }
});
myBarChart;
      }
      //
  }
}
</script>

<style scoped>

</style>
