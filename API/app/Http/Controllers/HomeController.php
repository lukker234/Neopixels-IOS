<?php

namespace App\Http\Controllers;

use App\Temps;
use App\Rasp_Registration;
use App\User_registration;
use Carbon\Carbon;
use DateTimeZone;


class HomeController extends Controller
{


    public function getTemps($date){
        $date_retrieved = Temps::where('created_at', $date)->get();
        return $date_retrieved;
    }

    public function getTempMac($rasp_mac){
        $mac_retrieved = Temps::where('rasp_mac', $rasp_mac)->orderBy('created_at', 'desc')->limit(1)->get();
        $test = User_registration::where('id',$mac_retrieved[0]['location_id'])->get();

        return array_merge($mac_retrieved+$test);
    }

    public function TempCompare($date,$rasp_mac){

        $date_begin = $date." 00:00:00";
        $date_end = $date." 23:59:59";

        $mac_retrieved = Temps::where('rasp_mac', $rasp_mac)->where('created_at','>=', $date_begin)->where('created_at','<', $date_end)->orderBy('created_at', 'asc')->get();

        //meting laten zien om de 4 uur dan begin je om 00 en eindig je op 24

        foreach ($mac_retrieved as $data){
            $datetime = date_create($data['created_at']);

            $sum[] = array('temp' => $data['temp'], 'air' => $data['air'], 'air_buiten' => $data['air_buiten'],'temp_buiten' => $data['temp_buiten'], 'time' => date_format($datetime,"H:m"),'amount' => '1');
        }

        $result = array_reduce($sum, function ($a, $b) {
            isset($a[$b['time']]) ?
                $a[$b['time']]['air'] += $b['air'] AND $a[$b['time']]['temp'] += $b['temp'] AND $a[$b['time']]['air_buiten'] += $b['air_buiten'] AND $a[$b['time']]['temp_buiten'] += $b['temp_buiten'] AND $a[$b['time']]['amount'] += $b['amount'] : $a[$b['time']] = $b;
            return $a;
        });

        foreach($result as $average){
            $avg_result[] = array('temp' => round($average['temp']/$average['amount'],2), 'air' => round($average['air']/$average['amount'],2),'air_buiten' => round($average['air_buiten']/$average['amount'],2),'temp_buiten' => round($average['temp_buiten']/$average['amount'],2), 'time' => $average['time'], 'rasp_mac' => $rasp_mac);
        }

        for ($i=0; $i<=count($avg_result); $i+=4) {
            if($i == 4){
                $i = 3;
                $final_temp[] = $avg_result[$i];
            }else{
                $final_temp[] = $avg_result[$i];
            }
        }

        return $final_temp;
    }

    public function avg_date($rasp_mac){
        $pastweek = Carbon::now(new DateTimeZone('Europe/London'))->subWeeks(1)->subDay(2);
        $time = "23:59:59";
        $time = explode(":", $time);

        $pastweek->setTime($time[0], $time[1], $time[2]);
        $today = Carbon::now(new DateTimeZone('Europe/London'))->subDay(1);

        $Last7Days = Temps::where('rasp_mac', $rasp_mac)->where('created_at' ,'>', $pastweek)->where('created_at' ,'<', $today)->orderBy('created_at', 'asc')->get();

        foreach ($Last7Days as $data){
            $datetime = date_create($data['created_at']);

            $sum[] = array('avg_temp' => $data['temp'], 'avg_air' => $data['air'], 'date' => date_format($datetime,"d-m"),'amount' => '1');
        }

        $result = array_reduce($sum, function ($a, $b) {
            isset($a[$b['date']]) ?
                $a[$b['date']]['avg_air'] += $b['avg_air'] AND $a[$b['date']]['avg_temp'] += $b['avg_temp'] AND $a[$b['date']]['amount'] += $b['amount'] : $a[$b['date']] = $b;
            return $a;
        });

        foreach($result as $average){
            $avg_result[] = array('avg_temp' => round($average['avg_temp']/$average['amount'],2), 'avg_air' => round($average['avg_air']/$average['amount'],2), 'date' => $average['date'], 'rasp_mac' => $rasp_mac);
        }

        return $avg_result;
    }

    public function checkMacRasp($mac_adres){
        $mac_retrieved = Rasp_Registration::where('mac_adres', $mac_adres)->get();
        return $mac_retrieved;
    }

    public function checkMacDevice($mac_adres){
        $mac_retrieved = User_registration::where('device_mac', $mac_adres)->get();
        return $mac_retrieved;
    }

    public function registerRasp($mac_rasp,$ip_rasp)
    {
        $temp = new Rasp_Registration();
        $temp->mac_adres       = $mac_rasp;
        $temp->ip_adres        = $ip_rasp;
        $temp->save();
    }

    public function registerUser($device_rasp, $rasp_mac, $location)
    {
        $user = new User_registration();
        $user->rasp_mac         = $rasp_mac;
        $user->device_mac       = $device_rasp;
        $user->location         = $location;
        $user->save();
    }

    public function setTempsNew($temp_value, $air, $device_adres, $rasp_mac, $local_ip, $temp_buiten,$air_buiten)
    {
        $location_id = User_registration::where('rasp_mac', $rasp_mac)->get();

        $temp = new Temps();
        $temp->location_id     = $location_id[0]['id'];
        $temp->temp            = $temp_value;
        $temp->air             = $air;
        $temp->device          = $device_adres;
        $temp->rasp_mac        = $rasp_mac;
        $temp->local_ip        = $local_ip;
        $temp->temp_buiten     = $temp_buiten;
        $temp->air_buiten      = $air_buiten;
        $temp->save();
    }

    public function getTempsAll(){
        return Temps::all();
    }

    public function getRegAll(){
        return Rasp_Registration::all();
    }

    public function getRegMac($mac_adres){
        $reg_retrieved = Rasp_Registration::where('mac_adres', $mac_adres)->get();
        return $reg_retrieved;
    }

    public function getTempsNow($rasp_mac){
        $today_begin = Carbon::now(new DateTimeZone('Europe/Amsterdam'));
        $today_end = Carbon::now(new DateTimeZone('Europe/Amsterdam'));
        $time = "00:00:00";
        $time = explode(":", $time);

        $time2 = "23:59:59";
        $time2 = explode(":", $time2);

        $today_begin->setTime($time[0], $time[1], $time[2]);
        $today_end->setTime($time2[0], $time2[1], $time2[2]);

        $mac_retrieved = Temps::where('rasp_mac', $rasp_mac)->where('created_at','>=', $today_begin)->where('created_at','<', $today_end)->orderBy('created_at', 'desc')->get()->first();
        $test = User_registration::where('id',$mac_retrieved['location_id'])->get();
        $locatie = $test[0]['location'];
        array_add($mac_retrieved,'Locatie',$locatie);

        return $mac_retrieved;
    }

    public function systemData($device_mac){
        $selected_rasp = User_registration::where('device_mac',$device_mac)->get();
        $mac_adres_rasp = $selected_rasp[0]['rasp_mac'];
        $collect_data_rasp = Rasp_Registration::where('mac_adres',$mac_adres_rasp)->get();
        $ip_adres = $collect_data_rasp[0]['ip_adres'];
        $location = $selected_rasp[0]['location'];
        $birth = $selected_rasp[0]['created_at'];
        $sensors = Temps::where('rasp_mac',$selected_rasp[0]['rasp_mac'])->get();

        foreach ($sensors as $p) {
            $avg_result[] = $p['device'];
        }

        $found_sensors = array_unique($avg_result);

        $system_information[] = [
            'ip_adres'      => $ip_adres,
            'mac_adres'     => $mac_adres_rasp,
            'location'      => $location,
            'date'          => $birth,
            'sensor'        => $found_sensors,
        ];

        return $system_information;
    }
}
