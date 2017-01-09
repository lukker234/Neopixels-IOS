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
        return $mac_retrieved;
    }

    public function TempCompare($date,$rasp_mac){

        $date_begin = $date." 00:00:00";
        $date_end = $date." 23:59:59";

        $mac_retrieved = Temps::where('rasp_mac', $rasp_mac)->where('created_at','>=', $date_begin)->where('created_at','<', $date_end)->orderBy('created_at', 'desc')->limit(7)->get();
        return $mac_retrieved;
    }

    public function avg_date($rasp_mac){
        $pastweek = Carbon::now(new DateTimeZone('Europe/London'))->subWeeks(1)->subDay(1);
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

    public function registerUser($device_rasp, $rasp_mac)
    {
        $user = new User_registration();
        $user->rasp_mac         = $rasp_mac;
        $user->device_mac       = $device_rasp;
        $user->save();
    }

    public function setTempsNew($temp_value, $air, $device_adres, $rasp_mac, $local_ip)
    {
        $temp = new Temps();
        $temp->temp            = $temp_value;
        $temp->air             = $air;
        $temp->device          = $device_adres;
        $temp->rasp_mac        = $rasp_mac;
        $temp->local_ip        = $local_ip;
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

    public function getTempsNow(){
        return Temps::all()->last();
    }
}
